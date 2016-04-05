class Department < ActiveRecord::Base
  has_many :sub_departments, class_name: 'Department', foreign_key: 'sup_department_id'
  belongs_to :sup_department,class_name: 'Department'
  has_many :tasks, as: :taskable
  has_many :department_users
  has_many :users, through: :department_users #all include admin and members
  has_many :plans
  # scope :have, -> { where(usertype: 'have') }   #下级部门，马总 have 财富个人中心
  # scope :admin, -> { where(usertype: 'admin') } #所属部门，管理者
  # scope :staff, -> { where(usertype: 'staff') } #所属部门，普通员工
  
  # scope :online, -> { published.where('deadline is NULL or deadline > ?', Date.today) }

  def has_sub_departments?
     sub_departments.size > 0
  end


  #返回成员
  def members  #shepujing zhangyajun chenjinxin 
    @members=Array.new 
    department_users.each do |x|
      @members << x.user  unless (x.role == 'admin' or x.role == 'have') 
    end
    @members
  end

  #返回管理者 适用于场景  哪些领导可以看这个部门的绩效考核
  def admins   #总监 副总监 有权限查看整个部门的  #互联网金融部 mahuijun  jinguorui maguoqing 
    @admins=Array.new  
    department_users.each do |x|
      @admins << x.user  if (x.role == 'admin' or x.role =='have')
    end
    @admins
  end

  #管理者与员工   不算上级领导
  def staff   #总监 副总监 有权限查看整个部门的  #互联网金融部 mahuijun  jinguorui maguoqing 
    @staff=Array.new  
    department_users.each do |x|
      @staff << x.user  unless (x.role == 'have')
    end
    @staff
  end

  def passageway_income

  end


  ################个人绩效考核###项目管理费收入计算###########################
  def count_income(between_date)
    sum = 0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.count_income(between_date)
      end
      return sum
    end
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模收入－－－－－＝＝＝＝＝＝"
    
    staff.each do |user|
      sum +=  user.count_income(between_date)
    end
    sum += channel_income(between_date)
    return sum
  end

  def channel_income(between_date)
    sum = 0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.channel_income(between_date)
      end
      return sum
    end
    Project.all.each do |p|
      sum += p.passageway_income(self,between_date)
    end
    return sum
  end
  ##################个人绩效考核###规模收入计算#############################
  def count_scale(dated=Date.current)
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模收入－－－－－＝＝＝＝＝＝"
    sum = 0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.count_scale(dated)
      end
      return sum
    end

    staff.each do |user|
      sum +=  user.count_scale(dated)
    end
    sum += channel_scale(dated)
    return sum
  end

  def channel_scale(dated=Date.current)
    sum=0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.channel_scale(dated)
      end
      return sum
    end

    Project.all.each do |p|
      sum += p.passageway_scale(self,dated)
    end
    sum
  end

  def count_annual_scale(between_date=Date.one_year)
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模收入－－－－－＝＝＝＝＝＝"
    sum = 0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.count_annual_scale(between_date)
      end
      return sum
    end
    staff.each do |user|
      sum +=  user.count_annual_scale(between_date)
    end
    sum += channel_annual_scale(between_date)
    return sum
  end

  def channel_annual_scale(between_date=Date.one_year)
    sum = 0.0
    if has_sub_departments?
      sub_departments.each do |sub_department|
        sum += sub_department.channel_annual_scale(between_date)
      end
      return sum
    end
    Project.all.each do |p|
      sum += p.passageway_annual_scale(self,between_date)
    end
    sum
  end
  ##########################################################################

  #统计资管计划管理费
  def count_plan_manage_fee(between_date)
    startd=between_date[0]
    endd=between_date[1]
    sum=0.0
    staff.each do |user|
      sum += user.count_plan_manage_fee(startd,endd)
    end
    sum
  end

  def count_co_fee(between_date)  #[]参数
    startd=between_date[0]
    endd=between_date[1]
    sum=0.0
    staff.each do |user|
      sum += user.count_fee_between(startd,endd)
    end
    sum
  end

  def count_fee(between_date)  #[]参数
    startd=between_date[0]
    endd=between_date[1]
    count_fee_between(startd,endd)
  end

  def count_scale_old(at_date)
    sum=0.0
    staff.each do |user|
      sum += user.count_scale(at_date)
    end
    sum
  end

  def count_fee_between(startd,endd)  #计算个人的计划与项目的管理费
    sum=0.0
    staff.each do |user|
      sum += user.count_fee_between(startd,endd)
    end
    sum
  end

  

  def count_all_type_task
    [count_scale_tasks,count_management_fee_tasks,count_fee_tasks]
  end

  def count_scale_tasks
    count_tasks(Task::TASK_TYPE[0])
  end
  def count_management_fee_tasks
    count_tasks(Task::TASK_TYPE[1])
  end
  def count_fee_tasks
    count_tasks(Task::TASK_TYPE[2])
  end

  def count_tasks(task_type)#部门的指标
    scale = 0.0;
    tasks.each do |task|
      scale += task.amount if task.task_type == task_type
    end
    scale
  end 

  def count_staffs_tasks(task_type) #汇总个人的任务  应该用部门单独的任务
    scale = 0.0;
    staff.each do |user|
      scale += user.count_tasks(task_type)
    end
    scale
  end
end
