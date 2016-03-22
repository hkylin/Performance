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

  def count_fee_self(startd,endd)
    bt=bt_start_end(startd,endd)
    (bt[1]-bt[0])*scale*rate/365   #计算管理费
  end

  def count_fee_modifys(startd,endd)
    sum=0.0
    modifications.each do |modify|
      sum = sum + modify.count_fee_between(startd,endd)
    end
    sum
  end

  def count_fee_between(startd,endd)
    if modifications.size > 0 
      count_fee_modifys(startd,endd)
    else
      count_fee_self(startd,endd)
    end
  end

  def count_scale(at_date) #计算单一计划管理费
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
