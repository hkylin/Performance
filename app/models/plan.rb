class Plan < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_many :projects, :dependent => :destroy
  has_many :modifications, as: :modificationable, :dependent => :destroy
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable

  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  PLAN_TYPE = %w(单一 集合)  
  validates_inclusion_of :plan_type, in: PLAN_TYPE

  RISK_TYPE = %w(正常 风险)  
  validates_inclusion_of :risk, in: RISK_TYPE
  
  # validates_presence_of :department
  validates_presence_of :start_date, :end_date, :name, :number, :plan_type, :rate   , :message => "不能为空" # 最少 2 #, :parter
  validates_length_of :name, :minimum => 4 ,:message => "名称最少4个字节" 
  validates_numericality_of :scale, :greater_than => 30000000, :message => "最小规模3000万" # 最少 2 
  validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 

  def count_fee_between(startd,endd)
    if projects.size > 0 
      count_fee_projects(startd,endd)
    else
      count_fee_self(startd,endd)
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
  def count_fee_self(startd,endd) #计算单一计划管理费
    #组织参数
    if(startd>=end_date)  #项目不在范围内,项目在查找周期之前
      return 0
    end
    if(start_date >= endd)  #项目不在范围内,项目在查找周期之后
      return 0
    end
    if((start_date-startd).to_i >0 )
      startd=start_date
    end
    if((endd-end_date).to_i >0 )
      endd=end_date
    end    
    (endd-startd)*scale*rate/365   #计算管理费
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
