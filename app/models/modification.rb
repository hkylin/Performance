class Modification < ActiveRecord::Base
  include BT

  # belongs_to :project
  belongs_to :modificationable, polymorphic: true
  belongs_to :user
  validates_associated :modificationable
  # has_many :cooperations
  has_many :cooperations, as: :cooperationable, dependent: :destroy, inverse_of: :cooperationable

  accepts_nested_attributes_for :cooperations, reject_if: :all_blank, allow_destroy: true

  CHARGE_TYPE = %w(普通 前端收费 后端收费)  
  validates_inclusion_of :charge_type, in: CHARGE_TYPE

  validates_presence_of :start_date, :end_date, :scale, :rate , :message => "不能为空" # 最少 2 #, :parter
  validates_numericality_of :scale, :greater_than_or_equal_to => 30000000, :message => "最小规模3000万",:allow_blank => true  # 最少 2 
  # :reject_if => :all_blank
  # reject_if: proc { |attributes| attributes['ratio'].blank? || attributes['ratio'].to_f > 1.0}
#TODO 如果超过1.0 不保存记录  但是也没有错误提示
  
  # t.date :start_date
  # t.date :end_date
  # t.decimal :management_fee管理费率
  # t.decimal :rate  费率
  # t.decimal :fee   费用金额
  # t.text :notes

  validates_presence_of :start_date, :end_date, :scale, :rate, :annual, :message => "不能为空" # 最少 2 
  # validates_numericality_of :scale, :greater_than => 30000000  , :message => "最小规模3000万" # 最少 2 
  # validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 

  after_initialize :default_values
  
  def default_values
    return unless new_record?
    self.charge_type ||= Plan::CHARGE_TYPE[0]
  end
  
  def count_co_fee_self(between_date,userr)
    logger.info "=========------开始计算修改:  -----=========="
    ratio = getCoRatio(userr) #修改中还存在我
    if (ratio!=nil) && (ratio!= [])
      bt = bt_start_end(between_date)
      logger.info(bt)
      return (bt[1]-bt[0])*scale*rate*ratio/annual   #计算管理费
    else
      0.0
    end
  end

  def count_fee_between(between_date)
    bt = bt_start_end(between_date)
    logger.info(bt)
    return (bt[1]-bt[0])*scale*rate/annual   #计算管理费
  end

  # validates :project_id, presence: true
  def self.find_projects
  	Project.all.collect { |project| [project.name, project.id] } 
  end
  
end
