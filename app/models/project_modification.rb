class ProjectModification < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates_associated :project
  has_many :cooperations

  accepts_nested_attributes_for :cooperations , update_only: true
  # t.date :start_date
  # t.date :end_date
  # t.decimal :management_fee管理费率
  # t.decimal :rate  费率
  # t.decimal :fee   费用金额
  # t.text :notes

  validates_presence_of :start_date, :end_date, :name, :number, :plan_type, :rate , :message => "不能为空" # 最少 2 
  validates_length_of :name, :minimum => 4, :message => "名称最少4个字节" 
  validates_numericality_of :scale, :greater_than => 30000000  , :message => "最小规模3000万" # 最少 2 
  validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  validates_uniqueness_of :name , :on => :create,:message => "计划名称不唯一"
  

  def count_fee_between(startd,endd)
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

  # validates :project_id, presence: true
  def self.find_projects
  	Project.all.collect { |project| [project.name, project.id] } 
  end
  
end
