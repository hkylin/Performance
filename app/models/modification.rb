class Modification < ActiveRecord::Base
  include BT

  # belongs_to :project
  belongs_to :modificationable, polymorphic: true
  belongs_to :user
  validates_associated :modificationable
  # has_many :cooperations
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable

  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true
  # :reject_if => :all_blank
  # reject_if: proc { |attributes| attributes['ratio'].blank? || attributes['ratio'].to_f > 1.0}
#TODO 如果超过1.0 不保存记录  但是也没有错误提示
  
  # t.date :start_date
  # t.date :end_date
  # t.decimal :management_fee管理费率
  # t.decimal :rate  费率
  # t.decimal :fee   费用金额
  # t.text :notes

  validates_presence_of :start_date, :end_date, :rate , :message => "不能为空" # 最少 2 
  # validates_numericality_of :scale, :greater_than => 30000000  , :message => "最小规模3000万" # 最少 2 
  # validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 
  
  def count_co_fee_self(startd,endd,userr)
    ratio = getCoRatio(userr) #修改中还存在我
    if ratio
      bt = bt_start_end(startd,endd)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
    else
      0.0
    end
  end

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
