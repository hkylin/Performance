class Project < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :plan

  belongs_to :department
  has_many :project_modifications, :dependent => :destroy

  validates_presence_of :start_date, :end_date, :name, :number, :rate   , :message => "不能为空" # 最少 2 
  validates_length_of :name, :minimum => 2 , :message => "名称最少4个字节" 
  validates_numericality_of :scale, :greater_than => 30000000 , :message => "最小规模3000万" # 最少 2 
  
  validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一" 
  
  def self.find_departments
  	Department.all.collect { |department| [department.name, department.id] } 
  end

  def self.find_plans
  	Plan.all.collect { |plan| [plan.name, plan.id] } 
  end   

  def count_fee_self(startd,endd)
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
    (endd-startd)*scale*rate/365
  end

  def count_fee_modifys(startd,endd)
    sum=0.0
    project_modifications.each do |modify|
      sum = sum + modify.count_fee_between(startd,endd)
    end
    sum
  end

  def count_fee_between(startd,endd)
    if project_modifications.size > 0 
      count_fee_modifys(startd,endd)
    else
      count_fee_self(startd,endd)
    end
  end

  def count_fee
    (end_date-start_date)*scale*rate/365
  end

  def count_date
    end_date-start_date
  end

end
