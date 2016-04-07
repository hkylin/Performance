class Project < ActiveRecord::Base
  include BT

  belongs_to :user
  belongs_to :plan
  belongs_to :department
  has_many :modifications, as: :modificationable, :dependent => :destroy
  
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable
  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  RISK_TYPE = %w(正常 风险)  
  validates_inclusion_of :risk, in: RISK_TYPE

  validates_presence_of :plan_id, :start_date, :end_date, :name, :rate   , :message => "不能为空" # 最少 2 
  validates_length_of :name, :minimum => 2 , :message => "名称最少4个字节", :allow_blank => true  
  validates_numericality_of :scale, :greater_than_or_equal_to => 30000000 , :message => "最小规模3000万" 
  validates_numericality_of :channel_cost, :greater_than_or_equal_to => 0.0 , :less_than_or_equal_to => 1.0 , :message => "请合理设置通道费用" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 


  scope :cc, -> { where("channel_cost > 0 AND channel_cost <=1") }   
  
  def self.find_departments
  	Department.all.collect { |department| [department.name, department.id] } 
  end

  def self.find_plans
  	Plan.all.collect { |plan| [plan.name, plan.id] } 
  end   

  ###################项目管理费收入计算###########################
  def count_income(userr,between_date)
    bt = bt_start_end(between_date)
    ratio = getCoRatio(userr)*(1-channel_cost)
    return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
  end
  #规模收入计算
  def count_scale(userr,dated=Date.current)
    if is_contain?(dated)
      ratio = getCoRatio(userr)*(1-channel_cost)
      logger.info "#{name}********"
      return scale*ratio   #计算管理费
    else
      return 0.0
    end
  end
  #年化的规模收入计算
  def count_annual_scale(userr,between_date=Date.one_year)
    bt = bt_start_end(between_date)
    ratio = getCoRatio(userr)*(1-channel_cost)
    return scale*ratio*(bt[1]-bt[0])/Date.year_days   #计算管理费
  end
  #项目使用外部计划通道，通道管理费收入计算
  def passageway_income(between_date)
    bt = bt_start_end(between_date)
    return (bt[1]-bt[0])*scale*rate*channel_cost/annual   #计算管理费
  end
  #项目使用外部计划通道，通道规模收入计算
  def passageway_scale(dated)
    if (is_contain?(dated))
      return scale*channel_cost   #计算管理费
    else
      return 0.0
    end
  end

  def passageway_annual_scale(between_date)
      bt = bt_start_end(between_date)
      return scale*channel_cost*(bt[1]-bt[0])/Date.year_days   #计算管理费
  end
  ##############################################################


  #通过cooperation计算，只计算单一计划，集合类计划不计算
  def count_co_fee_between(between_date,userr)
    count_co_fee_self(between_date,userr)
  end

  def count_co_fee_self(between_date, userr )
    logger.info "=========------开始计算项目:  #{name}-----=========="
    if modifications.size == 0
      bt = bt_start_end(between_date)
      ratio = getCoRatio(userr)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
    else
      sum = 0.0
      modifications.each do |mo|
        fee=mo.count_co_fee_self(between_date,userr)
        sum += fee
        logger.info fee
      end   
      return sum   
    end
  end

  def count_fee_self(between_date)
    bt=bt_start_end(between_date)
    (bt[1]-bt[0])*scale*rate/365   #计算管理费
  end

  def count_fee_modifys(between_date)
    sum=0.0
    modifications.each do |modify|
      sum = sum + modify.count_fee_between(between_date)
    end
    sum
  end

  def count_fee_between(between_date)
    if modifications.size > 0 
      count_fee_modifys(between_date)
    else
      count_fee_self(between_date)
    end
  end

  def count_scale_old(at_date) #计算单一计划管理费
    if modifications.size > 0
      count_scale_modifys at_date
    else
      count_scale_self at_date      
    end
  end

  def count_scale_self(at_date)
    if( start_date <= at_date && at_date < end_date )  #注意开始时间  结束时间边界值
      return scale
    else
      return 0
    end 
  end

  def count_scale_modifys(at_date)  #modify日期必须是连续的
    modifications.each do |modify|
      if( modify.start_date <= at_date && at_date < modify.end_date )  #注意开始时间  结束时间边界值
        return modify.scale
      end
    end
  end

  def count_fee
    (end_date-start_date)*scale*rate/365
  end

  def count_date
    end_date-start_date
  end



end

