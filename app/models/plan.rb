class Plan < ActiveRecord::Base
  include BT
  belongs_to :user
  belongs_to :department
  has_many :projects, :dependent => :destroy
  has_many :modifications, as: :modificationable, :dependent => :destroy
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable

  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  PLAN_TYPE = %w(单一 集合)  
  validates_inclusion_of :plan_type, in: PLAN_TYPE
  
  ENTRUST_TYPE = %w(一对一 一对多)  
  validates_inclusion_of :entrust_type, in: ENTRUST_TYPE

  RISK_TYPE = %w(正常 风险)  
  validates_inclusion_of :risk, in: RISK_TYPE
  
  # validates_presence_of :department
  validates_presence_of :start_date, :end_date, :name, :number, :plan_type, :rate   , :message => "不能为空" # 最少 2 #, :parter
  validates_length_of :name, :minimum => 4 ,:message => "名称最少4个字节" 
  validates_numericality_of :scale, :greater_than => 30000000, :message => "最小规模3000万" # 最少 2 
  validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 

  after_initialize :default_values
    def default_values
      return unless new_record?
      self.plan_type ||= Plan::PLAN_TYPE[0]
      self.entrust_type ||= Plan::ENTRUST_TYPE[0]
      self.risk ||= Plan::RISK_TYPE[0]
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


  def count_fee_between(startd,endd)
    # if projects.size > 0   #是判断是否有多个项目还是判断是否是单个资管计划？
    if plan_type == Plan::PLAN_TYPE[1] #一对多项目
      count_fee_projects(startd,endd)
    else
      count_fee_self(startd,endd)
    end
  end

  def getCoRatio(userr)
    cooperations.each do |co|
      if(co.user==userr)
        return co.ratio
      end 
    end
  end

  #通过cooperation计算，只计算单一计划，集合类计划不计算
  def count_co_fee_between(startd,endd,userr)
    count_fee_self(startd,endd,userr)
  end

  def count_co_fee_self(startd,endd,userr)
    if modifications.size == 0
      bt = bt_start_end(startd,endd)
      ratio = getCoRatio(userr)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
    else
      fee = 0.0
      modifications.each do |mo|
        fee += mo.count_co_fee_self(startd,endd,userr)
      end   
      return fee   
    end
  end

  def count_fee
    (end_date-start_date)*scale*rate/365
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
  # def bt_start_end(startd,endd)
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
  #   [startd,endd] 
  # end

  def count_fee_self(startd,endd) #计算单一计划管理费
    bt=bt_start_end(startd,endd)
    (bt[1]-bt[0])*scale*rate/annual   #计算管理费
  end

  def count_fee_projects(startd,endd) #计算组合计划，多个项目的汇总
    sum=0.0
    projects.each do |project|
      sum = sum + project.count_fee_between(startd,endd)
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
