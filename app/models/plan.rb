class Plan < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_many :projects, :dependent => :destroy

  PLAN_TYPE = %w(单一 集合)
  
  validates_inclusion_of :plan_type, in: PLAN_TYPE
  # validates_presence_of :department


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
