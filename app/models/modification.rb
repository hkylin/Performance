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

  validates_presence_of :start_date, :end_date, :scale, :rate, :annual, :message => "不能为空" # 最少 2 
  validates_numericality_of :channel_cost, :greater_than_or_equal_to => 0.0 , :less_than_or_equal_to => 1.0 , :message => "请合理设置通道费用" 
  validates_numericality_of :scale, :greater_than_or_equal_to => 30000000 , :message => "最小规模3000万" 
  # validates_uniqueness_of :number,  :on => :create, :message => "计划编号不唯一" 

  after_initialize :default_values
  
  def default_values
    return unless new_record?
    self.charge_type ||= Plan::CHARGE_TYPE[0]
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

  alias :mo_count_income :count_income
  alias :mo_count_scale :count_scale
  alias :mo_count_annual_scale :count_annual_scale
  alias :mo_passageway_income :passageway_income
  alias :mo_passageway_scale :passageway_scale
  alias :mo_passageway_annual_scale :passageway_annual_scale
  ##############################################################


  
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
