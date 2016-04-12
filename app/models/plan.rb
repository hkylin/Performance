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
  validates_presence_of :start_date, :end_date, :name, :scale, :number, :plan_type, :rate   , :message => "不能为空" # 最少 2 #, :parter
  validates_length_of :name, :minimum => 4 ,:message => "名称最少4个字节", :allow_blank => true 
  validates_numericality_of :scale, :greater_than_or_equal_to => 30000000, :message => "最小规模3000万",:allow_blank => true  # 最少 2 
  validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 

  after_initialize :default_values

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

###########################计算计划的费用，支持分段，修改##############################
  #今年以来的资管计划已经计提的费用  
  def this_year_fee
    return count_plan_manage_fee(Date.since_this_year)
  end

  #资管计划的全部费用，开始时间到结束时间
  def whole_plan_fee
    return count_plan_manage_fee([start_date,end_date])
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
    modifications.each do |mo|
      if mo.is_contain?(dated)
        return mo.scale
      end
    end   
    return 0.0   
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
      bt = bt_start_end(between_date)
      logger.info(bt)
      ratio = getCoRatio(userr)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
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
  # def bt_start_end(between_date)
  #   #组织参数
  #   if(startd>=end_date)  #项目不在范围内,项目在查找周期之前
  #     return 0
  #   end
  #   if(start_date >= endd)  #项目不在范围内,项目在查找周期之后
  #     return 0
  #   end
  #   if((start_date-startd).to_i >0 )
  #     startd=start_date
  #   end
  #   if((endd-end_date).to_i >0 )
  #     endd=end_date
  #   end 
  #   [between_date] 
  # end



  def count_fee_self(between_date) #计算单一计划管理费
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

end
