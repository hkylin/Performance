class Plan < ActiveRecord::Base
  include BT
  belongs_to :user
  belongs_to :department
  has_many :projects, :dependent => :destroy
  has_many :modifications, as: :modificationable, :dependent => :destroy
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable

  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  PLAN_TYPE = %w(一对一 一对多)  
  validates_inclusion_of :plan_type, in: PLAN_TYPE

  CHARGE_TYPE = %w(普通 前端收费 后端收费)  
  validates_inclusion_of :charge_type, in: CHARGE_TYPE  
  
  # t.string :ownership_type  #归属类型  行内|行外
  # t.string :model_type #业务归属


  OWNERSHIP_TYPE = %w(行内 行外)  
  validates_inclusion_of :ownership_type, in: OWNERSHIP_TYPE  

  RISK_TYPE = %w(正常 风险)  
  validates_inclusion_of :risk, in: RISK_TYPE
  
  # validates_presence_of :department
  validates_presence_of :start_date, :end_date, :name, :scale, :plan_type, :rate   , :message => "不能为空" # 最少 2 #, :parter
  validates_length_of :name, :minimum => 4 ,:message => "名称最少4个字节", :allow_blank => true 
  # validates_numericality_of :scale, :greater_than_or_equal_to => 1000000, :message => "最小规模100万",:allow_blank => true  # 最少 2 
  # validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 
  validates_numericality_of :scale
  # validates_numericality_of :charge_amount

  after_initialize :default_values
  #annual  ==0  按照实际天数计算

  def default_values
    return unless new_record?
    self.plan_type ||= Plan::PLAN_TYPE[0]
    self.charge_type ||= Plan::CHARGE_TYPE[0]
    self.risk ||= Plan::RISK_TYPE[0]
    self.ownership_type ||= Plan::OWNERSHIP_TYPE[0]
    self.scale ||= 30000000.0
    self.rate ||= 0.004
    # if (self.cooperations.size == 0)
    #   self.cooperations.build
    #   self.cooperations[0].user = user
    #   self.cooperations[0].ratio = 1.0      
    #   logger.info "===========---------#{user}-----------============="
    #   logger.info "===========---------#{cooperations[0]}-----------============="
    #   logger.info "===========---------#{cooperations[0].user}-----------============="
    #   logger.info "===========---------#{cooperations[0].ratio}-----------============="
    # end
  end

  def back_calc
      self.m_whole_fee = whole_plan_fee 
      self.m_year_fee = this_year_fee 
      self.m_scale = count_plan_scale
      self.mm_scale = mobility_scale 
      logger.info "back_calc-----#{self.name}   #{self.m_whole_fee}"
  end

  def self.to_csv(options = {})
    csv_res=CSV.generate(options) do |csvv|
      names = %w[资管计划编号 资管计划名称 资管计划类型 收费模式 前后端收费金额 固定费用收取日期 规模 成立日期 到期日 管理费 投资经理 部门 管理费率 费用金额 计划创建者 合作伙伴 备注 归属类型 产品模式 年化 风险 总管理费 本年已计提管理费 一季度管理费 二季度管理费 三季度管理费 四季度管理费 当前规模 流动性规模 添加日期 更新日期]
      csvv << names

        Plan.all.each do |p|
            csv=Array.new
            csv << p.number
            csv << p.name
            csv << p.plan_type
            csv << p.charge_type
            csv << p.charge_amount
            csv << p.charge_date
            csv << p.scale
            csv << p.start_date
            csv << p.end_date
            csv << p.management_fee
            csv << p.investment_manager
            csv << p.department_id
            csv << p.rate
            csv << p.fee
            csv << p.user_id
            csv << p.parter
            csv << p.notes
            csv << p.ownership_type
            csv << p.model_type
            csv << p.annual     
            csv << p.risk
            csv << p.m_whole_fee
            csv << p.m_year_fee
            csv << p.count_plan_manage_fee(Date.first_quarter)
            csv << p.count_plan_manage_fee(Date.second_quarter)
            csv << p.count_plan_manage_fee(Date.third_quarter)
            csv << p.count_plan_manage_fee(Date.fourth_quarter)
            csv << p.m_scale
            csv << p.mm_scale
            csv << p.created_at
            csv << p.updated_at

            csvv << csv
          end
      end
    end

###########################计算计划的费用，支持分段，修改##############################
  #今年以来的资管计划已经计提的费用  
  def this_year_fee
    return count_plan_manage_fee(Date.since_this_year)
  end

  #资管计划的全部费用，开始时间到结束时间
  def whole_plan_fee
    return count_whole_plan_manage_fee
  end

  def count_whole_plan_manage_fee  #计算个人的计划与项目的管理费
    logger.info "=========------开始计算资管计划－－#{name}管理费：----包含修改次数：#{modifications.size}---=========="
    if modifications.size == 0
      return count_manage_fee([start_date,end_date])
    else
      sum = 0.0
      modifications.each do |mo|
        fee = mo.count_manage_fee([mo.start_date,mo.end_date])
        logger.info "======---------#{mo}--------#{fee}---------=========="
        sum += fee
      end   
      return sum   
    end
  end

  #计算管理费收入
  def count_plan_manage_fee(between_date)  #计算个人的计划与项目的管理费
    logger.info "=========------开始计算资管计划－－#{name}管理费：----包含修改次数：#{modifications.size}---=========="
    if modifications.size == 0
      return count_manage_fee(between_date)
    else
      sum = 0.0
      modifications.each do |mo|
        fee = mo.count_manage_fee(between_date)
        logger.info "======---------#{mo}--------#{fee}---------=========="
        sum += fee
      end   
      return sum   
    end
  end

  def count_plan_scale(dated=Date.current)
    if modifications.size == 0
      if is_contain?(dated)
        return scale
      else
        return 0.0
      end
    end
    sum = 0.0
    modifications.each do |mo|
      if mo.is_contain?(dated)
        sum += mo.scale
      end
    end   
    return sum
  end

  def passageway_income(between_date)  #计算资管计划的通道费用
    sum = 0.0
    projects.each do |p|
      sum += p.passageway_income(between_date)
    end
    sum
  end

  def passageway_scale(dated)
    sum = 0.0
    projects.each do |p|
      sum += p.passageway_scale(dated)
    end
    sum
  end

  #计算计划流动性
  def mobility_scale(dated=Date.current)
    scale1=count_plan_scale(dated)
    return 0.0 if (scale1==0.0)
    projects.each do |p|
        scale1 -= p.count_full_scale if p.is_contain?(dated)
      end
    return scale1
  end


  #################################################################################

  def count_fee_between(between_date)
    # if projects.size > 0   #是判断是否有多个项目还是判断是否是单个资管计划？
    if plan_type == Plan::PLAN_TYPE[1] #一对多项目
      count_fee_projects(between_date)
    else
      count_fee_self(between_date)
    end
  end

  

  #通过cooperation计算，只计算单一计划，集合类计划不计算
  def count_co_fee_between(between_date,userr)
    count_co_fee_self(between_date,userr)
  end

  def count_co_fee_self(between_date,userr)
    logger.info "=========------开始计算计划:  #{name}----#{modifications.size}---=========="
    if modifications.size == 0
      ratio = getCoRatio(userr)
      if annual!=0    #是否是按照年实际天数计算
        bt = bt_start_end(between_date)
        logger.info(bt)
        return 0 if (bt==0)
        return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
      else
        sum=0.0
        bts = bt_start_ends(between_date)
        return 0 if (bts==0)
        bts.each do |x|
          sum+=(x[1]-x[0])*scale*rate*ratio/x[2]   #计算管理费
        end
        return sum
      end
    else
      sum = 0.0
      modifications.each do |mo|
        fee = mo.count_co_fee_self(between_date,userr)
        logger.info "======---------#{mo}--------#{fee}---------=========="
        sum+=fee
      end   
      return sum   
    end
  end

  def count_fee
    count_fee_between([start_date,end_date])
  end

#对集合类项目  没有做特殊的处理  
  def count_scale(at_date) #计算单一计划管理费
    #组织参数
    if( start_date <= at_date && at_date < end_date )  #注意开始时间  结束时间边界值
      return scale
    else
      return 0
    end
  end
 
  

protected

  def count_fee_self(between_date) #计算单一计划管理费    DELME?
    # bt=bt_start_end(between_date)
    # (bt[1]-bt[0])*scale*rate/annual   #计算管理费

    logger.info "=========------开始计算计划:  #{name}----#{modifications.size}---=========="
    if modifications.size == 0
      bt = bt_start_end(between_date)
      logger.info(bt)
      return (bt[1]-bt[0])*scale*rate/annual   #计算管理费
    else
      sum = 0.0
      modifications.each do |mo|
        fee = mo.count_fee_between(between_date)
        logger.info "======---------#{mo}--------#{fee}---------=========="
        sum+=fee
      end   
      return sum   
    end
  end

  def count_fee_projects(between_date) #计算组合计划，多个项目的汇总
    sum=0.0
    projects.each do |project|
      sum = sum + project.count_fee_between(between_date)
    end
    sum
  end

  def count_date
    end_date-start_date
  end

  def self.find_departments
  	Department.all.collect { |department| [department.name, department.id] } 
  end

  def self.find_plans
  	Plan.all.collect { |plan| [plan.name, plan.id] } 
  end   

  def to_s
    "#{name} #{start_date} #{end_date}"
  end

end
