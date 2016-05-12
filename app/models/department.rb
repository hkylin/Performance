class Department < ActiveRecord::Base
  has_many :sub_departments, class_name: 'Department', foreign_key: 'sup_department_id'
  belongs_to :sup_department,class_name: 'Department'
  has_many :tasks, as: :taskable
  has_many :department_users
  has_many :users, through: :department_users do  #all include admin and members
    def staff
      where("department_users.role=?",'staff') 
    end
    def admins
      where("department_users.role=? OR department_users.role=?", 'admin','have')
    end
    def members
      where("department_users.role=? OR department_users.role=?", 'admin','staff')
    end
  end
  has_many :plans
  has_many :projects

  # Client.includes("orders").where(first_name: 'Ryan', orders: { status: 'received' }).count

  # scope :have, -> { where(usertype: 'have') }   #下级部门，马总 have 财富个人中心
  # scope :admin, -> { where(usertype: 'admin') } #所属部门，管理者
  # scope :staff, -> { where(usertype: 'staff') } #所属部门，普通员工
  
  # scope :online, -> { published.where('deadline is NULL or deadline > ?', Date.today) }

  #事业部层面得到所有成员
  def grandsons  
    grandsons = Array.new
    sub_departments.each do |sub_department|
      sub_department.users.each do |u|
        grandsons << u
      end
    end
    return grandsons
  end

  def back_calc
      if has_sub_departments?
        logger.info "＝＝＝＝＝＝＝＝－－－－－计算：子部门收入－－－－－＝＝＝＝＝＝"
        sub_departments.each do |sub_department|
          sub_department.back_calc
          sub_department.save
        end
      end
      self.income_current = count_income2 Date.since_this_year 
      self.income_year = count_income2 Date.one_year 
      self.income_q1 = count_income2 Date.first_quarter 
      self.income_q2 = count_income2 Date.second_quarter 
      self.income_q3 = count_income2 Date.third_quarter 
      self.income_q4 = count_income2 Date.fourth_quarter 
      self.scale_current = count_scale2
      self.channel_income_current = channel_income Date.since_this_year 
      self.channel_income_year = channel_income Date.one_year 
      self.channel_income_q1 = channel_income Date.first_quarter 
      self.channel_income_q2 = channel_income Date.second_quarter 
      self.channel_income_q3 = channel_income Date.third_quarter 
      self.channel_income_q4 = channel_income Date.fourth_quarter 
      self.channel_scale_current = channel_scale
  end

  def self.plan_manager?(userr)
    Department.find_by_name('合作支持部').members.include?(userr)
  end

  def has_sub_departments?
     sub_departments.size > 0
  end

  #返回成员
  def staff  #shepujing zhangyajun chenjinxin 
    return users.staff
  end

  #返回管理者 适用于场景  哪些领导可以看这个部门的绩效考核
  def admins   #总监 副总监 有权限查看整个部门的  #互联网金融部 mahuijun  jinguorui maguoqing 
    return users.admins
  end

  #管理者与员工   不算上级领导
  def members   #总监 副总监 有权限查看整个部门的  #互联网金融部 mahuijun  jinguorui maguoqing 
    return users.members
  end
  ################个人绩效考核###项目管理费收入计算###########################
  def count_income(between_date)
    logger.info "＝＝＝＝＝＝＝＝－－－－－开始部门收入－－－－－＝＝＝＝＝＝"
    sum = 0.0
    if has_sub_departments?
      logger.info "＝＝＝＝＝＝＝＝－－－－－计算：子部门收入－－－－－＝＝＝＝＝＝"
      sub_departments.each do |sub_department|
        sum += sub_department.count_income(between_date)
      end
      return sum
    end
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}收入－－－－－＝＝＝＝＝＝"
    
    members.each do |user|
      income = user.count_income(between_date)
      logger.info "---#{user.name}--income:-#{income}------"
      sum +=  income
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
    projects.each do |p|
      sum += p.passageway_income(between_date)
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

    members.each do |user|
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

    projects.each do |p|
      sum += p.passageway_scale(dated)
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
    members.each do |user|
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
    projects.each do |p|
      sum += p.passageway_annual_scale(between_date)
    end
    sum
  end

  
  #####################
  #该部门名下所有计划规模总和 +/- 与他人合作项目规模占比
  def count_scale2(dated=Date.current)
    sum = 0.0
    if has_sub_departments?
      logger.info "＝＝＝＝#{self.name}＝＝＝＝－－－－－计算：子部门规模－－－－－＝＝＝＝＝＝"
      sub_departments.each do |sub_department|
        sum += sub_department.count_scale2(dated)
      end
      return sum
    end
    logger.info "＝＝＝＝＝＝#{self.name}＝＝－－－－－计算：部门规模－－－－－＝＝＝＝＝＝"
    return count_plans_scale(dated)-count_inproject_outuser_scale(dated)+count_outproject_inuser_scale(dated)
  end
  
  def count_plans_scale(dated)
    sum=0.0
    plans.each do |p|
      sum+=p.count_plan_scale(dated)
    end
    logger.info "＝＝＝＝＝＝＝＝－－－－－count_plans_scale计算规模：#{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end
  
  def count_inproject_outuser_scale(dated)
    sum=0.0
    logger.info "＝＝＝＝＝＝＝＝－－－－－count_inproject_outuser_scale计算规模：begining－－－－－＝＝＝＝＝＝"
    projects.each do |p| #我部带有通道费的项目
      logger.info "------#{p.name}------"
      p.cooperations.each do |c|
        logger.info "------#{c.user.name}------"
        unless(members.include?(c.user))
          logger.info "-----外部用户-#{c.user.name}------"
          sum+=p.count_scale(c.user,dated)
        end
      end
    end
    logger.info "＝＝＝＝＝＝＝＝－－－－－count_inproject_outuser_scale计算规模：#{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end

  def count_outproject_inuser_scale(dated)
    # projects = Project.includes(:cooperations).where.not(user: self).where(cooperations:{user: self})
    logger.info "＝＝＝＝＝＝＝＝－－－－－count_outproject_inuser_scale计算规模：begining－－－－－＝＝＝＝＝＝"
    sum=0.0
    members.each do |m|
      logger.info "＝＝＝＝＝＝＝＝－－－－－count_outproject_inuser_scale 内部协作者#{m}－－－－－＝＝＝＝＝＝"    
      projects = Project.includes(:cooperations).where.not(department: self).where(cooperations:{user: m})#外部门项目，但是合作者有我部门员工
      logger.info "＝＝＝＝＝＝＝＝－－－－－count_outproject_inuser_scale 内部协作者#{m} 项目数 #{projects.size}－－－－－＝＝＝＝＝＝"    
      projects.each do |p|
      logger.info "＝＝＝＝＝＝＝＝－－－－－count_outproject_inuser_scale 外部项目#{p.name},内部协作者#{m}－－－－－＝＝＝＝＝＝"    
        sum+=p.count_scale(m,dated)#计算该员工规模比例coun
      end
    end 
    logger.info "＝＝＝＝＝＝＝＝－－－－－count_outproject_inuser_scale计算规模：#{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end

  #该部门名下所有计划管理费总和 +/- 与他人合作项目管理费占比
  def count_income2(between_date=Date.since_this_year)
    sum = 0.0
    if has_sub_departments?
      logger.info "＝＝＝＝＝＝＝＝－－－－－计算：子部门收入－－－－－＝＝＝＝＝＝"
      sub_departments.each do |sub_department|
        sum += sub_department.count_income2(between_date)
      end
      return sum
    end
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算：部门收入－－－－－＝＝＝＝＝＝"
    return count_plans_income(between_date)-count_inproject_outuser_income(between_date)+count_outproject_inuser_income(between_date)
  end

  def count_plans_income(between_date)
    sum=0.0
    plans.each do |p|
      sum+=p.count_plan_manage_fee(between_date)
    end
    logger.info "count_plans_income   #{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end
  
  def count_inproject_outuser_income(between_date)
    sum=0.0
    projects.each do |p| #我部带有通道费的项目
      p.cooperations.each do |c|
        unless(members.include?(c.user))
          sum+=p.count_income(c.user,between_date)
        end
      end
    end
    logger.info "count_inproject_outuser_income#{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end

  def count_outproject_inuser_income(between_date)
    # projects = Project.includes(:cooperations).where.not(user: self).where(cooperations:{user: self})
    sum=0.0
    members.each do |m|
      projects = Project.includes(:cooperations).where.not(department: self).where(cooperations:{user: m})#外部门项目，但是合作者有我部门员工
      projects.each  do |p|
        sum+=p.count_income(m,between_date)#计算该员工规模比例
      end
    end 
    logger.info "count_outproject_inuser_income#{sum}－－－－－＝＝＝＝＝＝"
    return sum
  end

  ##########################################################################

  #统计部门员工的资管计划管理费---应该不用了
  def count_plan_manage_fee(between_date)
    startd=between_date[0]
    endd=between_date[1]
    sum=0.0
    members.each do |user|
      sum += user.count_plan_manage_fee(startd,endd)
    end
    sum
  end

  def count_co_fee(between_date)  #[]参数
    startd=between_date[0]
    endd=between_date[1]
    sum=0.0
    members.each do |user|
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
    members.each do |user|
      sum += user.count_scale(at_date)
    end
    sum
  end

  def count_fee_between(startd,endd)  #计算个人的计划与项目的管理费
    sum=0.0
    members.each do |user|
      sum += user.count_fee_between(startd,endd)
    end
    sum
  end

  def count_first_task#TODO 任务指标  目前只做了 管理费  ，这是一个必须修改的地方
    count_management_fee_tasks/4    
  end

  def count_scale_tasks
    tasks.each do |t|
      if(t.year == Date.current.year)
        return t.amount
      end
    end
    return 0.0
  end

  def count_management_fee_tasks
    tasks.each do |t|
      if(t.year == Date.current.year)
        return t.profit
      end
    end
    return 0.0
  end

end
