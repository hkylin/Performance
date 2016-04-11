class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tasks, as: :taskable
  has_many :department_users  #中间表
  has_many :departments, through: :department_users  #实际使用的

  has_many :plans
  has_many :projects
  has_many :modifications
  has_many :cooperations

  ROLES = %i[super_admin admin staff]
  
  # create_table "cooperations", force: :cascade do |t|
  #   t.integer  "user_id"
  #   t.integer  "cooperationable_id"
  #   t.string   "cooperationable_type"
  #   t.decimal  "ratio"
  #   t.datetime "created_at",           null: false
  #   t.datetime "updated_at",           null: false
  # end

  #是我参与,但不是我创建的
  def my_projects 
    # projects=[];
    # cooperations.each do |co|
    #   #非我创建，但我参与项目
    #   if (co.cooperationable.class == Project && co.cooperationable.user != self)
    #     projects << co.cooperationable
    #   end
    # end
    # puts projects.size
    # return projects

    projects = Project.includes(:cooperations).where.not(user: self).where(cooperations:{user: self})

    # return Project.includes(:cooperations).where('user!=? AND cooperations.user=? ',self,self)
    # return Project.includes(:cooperations).where(user: self,cooperations:{user: self})
    # Post.includes(:comments).where("comments.visible" => true)
    # return cooperations.includes(:cooperationable).where('cooperationable_type=? AND cooperations.user!=?','Project',self)
    # Cooperation.includes("cooperations").where(cooperationable_type: 'Project',cooperationable_id )
    # Client.includes("orders").where(first_name: 'Ryan', orders: { status: 'received' }).count
    # Client.includes("orders").where(first_name: 'Ryan', orders: { status: 'received' }).count
  end

  ################个人绩效考核###项目管理费收入计算###########################
  def count_income(between_date)
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模收入－－－－－＝＝＝＝＝＝"
    sum = 0.0
    cooperations.each do |co|
      logger.info "对象： #{co.cooperationable}＝＝＝＝＝＝＝＝－－－－－－－－－－＝＝＝＝＝＝"
      logger.info "类： #{co.cooperationable.class}   "
      # 非集合类资管计划, 项目类，修改类modifiy不在这里，由计划和项目进去
      if (co.cooperationable.class == Project)
        fee = co.cooperationable.count_income(self,between_date)
        logger.info "#{co.cooperationable.name} 计算费用= #{fee}"
        sum += fee
      end
    end
    sum
  end
  ##################个人绩效考核###规模收入计算#############################
  def count_scale(dated=Date.current)
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模－－－－－＝＝＝＝＝＝"
    sum = 0.0
    cooperations.each do |co|
      if (co.cooperationable.class == Project)
        scale = co.cooperationable.count_scale(self,dated)
        logger.info "#{co.cooperationable.name} 计算规模= #{scale}"
        sum += scale
      end
    end
    sum
  end

  def count_annual_scale(between_date=Date.one_year)
    logger.info "＝＝＝＝＝＝＝＝－－－－－计算： 用户 #{name}规模－－－－－＝＝＝＝＝＝"
    sum = 0.0
    cooperations.each do |co|
      if (co.cooperationable.class == Project)
        scale = co.cooperationable.count_annual_scale(self,between_date)
        logger.info "#{co.cooperationable.name} 计算年华规模= #{scale}"
        sum += scale
      end
    end
    sum
  end
  ##########################################################################

  def count_co_fee(between_date)  #计算个人的计划与项目的管理费
    count_co_fee_between(between_date)    
  end

  def count_co_fee_between(between_date)  #计算个人的计划与项目的管理费
      sum = 0.0
      cooperations.each do |co|
        logger.info "对象： #{co.cooperationable}＝＝＝＝＝＝＝＝－－－－－－－－－－＝＝＝＝＝＝"
        logger.info "类： #{co.cooperationable.class}   "
        # 非集合类资管计划, 项目类，修改类modifiy不在这里，由计划和项目进去
        if((co.cooperationable.class == Plan) && (co.cooperationable.plan_type == Plan::PLAN_TYPE[0]))
          fee = co.cooperationable.count_co_fee_between(between_date,self)
          logger.info "资管计划类型= #{co.cooperationable.plan_type}"  
          logger.info "计算的费用= #{fee}"  
        elsif (co.cooperationable.class == Project)
          fee = co.cooperationable.count_co_fee_between(between_date,self)
        else
          fee =0.0
        end
        logger.info "计算的费用= #{fee}"
        sum += fee
      end
      sum
  end

  #子部门以及一级分管部门，没有迭代任何它们的子部门。 
  def admin_departments
    @admin_departments=Array.new 
    department_users.each do |x|
      if ( x.role == 'admin'  )
        @admin_departments << x.department
        x.department.sub_departments.each do |y|
          @admin_departments << y
        end
      elsif ( x.role =='have' )
         @admin_departments << x.department
      end
    end
    @admin_departments
  end

  def current_department
    @admin_departments=Array.new 
    department_users.each do |x|
      if ( x.role == 'admin'  )
        @admin_departments << x.department
      end
    end
    @admin_departments
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

  def count_scale_old(at_date)
    sum=0.0
    plans.each do |plan|
      sum = sum + plan.count_scale(at_date)
    end
    projects.each do |project|
        sum = sum + project.count_scale(at_date)
      end
    sum
  end

  #TODO require 'date' #为什么date没有复写

  def count_first_fee
    count_fee_between(Date.new(Date.current.year,1,1), Date.new(Date.current.year,4,1))
  end
  def count_second_fee
    count_fee_between(Date.new(Date.current.year,4,1), Date.new(Date.current.year,7,1))
  end
  def count_third_fee
    count_fee_between(Date.new(Date.current.year,7,1), Date.new(Date.current.year,10,1))
  end
  def count_fourth_fee
    count_fee_between(Date.new(Date.current.year,10,1), Date.new(Date.current.year+1,1,1))
  end



  def count_fee_between(between_date)  #计算个人的计划与项目的管理费
      sum=0.0
      plans.each do |plan|
        sum = sum + plan.count_fee_between(between_date)   
      end
      projects.each do |project|
        sum = sum + project.count_fee_between(between_date)
      end
      sum
  end

  def count_fee(between_date)  #计算个人的计划与项目的管理费
      startd=between_date[0]
      endd=between_date[1]
      count_fee_between(between_date)
  end

  def quarters
    y1 = count_income Date.one_year
    q1 = count_income Date.first_quarter
    q2 = count_income Date.second_quarter
    q3 = count_income Date.third_quarter
    q4 = count_income Date.fourth_quarter
    s1 = count_scale
    s2 = count_annual_scale
    # [y1.to_i,q1.to_i,q2.to_i,q3.to_i,q4.to_i,s1.to_i,s2.to_i]
      [y1.to_i,q1.to_i,q2.to_i,q3.to_i,q4.to_i]
  end

  def months
    m1 = count_income Date.January
    m2 = count_income Date.February
    m3 = count_income Date.March
    m4 = count_income Date.April
    m5 = count_income Date.May
    m6 = count_income Date.June
    m7 = count_income Date.July
    m8 = count_income Date.August
    m9 = count_income Date.September
    m10 = count_income Date.October
    m11 = count_income Date.November
    m12 = count_income Date.December
    [m1.to_i, m2.to_i, m3.to_i, m4.to_i, m5.to_i, m6.to_i, m7.to_i, m8.to_i, m9.to_i, m10.to_i, m11.to_i, m12.to_i] 
  end

  def to_s
    username
  end
  
  #has_many :department_users
  def name
    username
  end

  # def sonUser
  # 	Array.new 
  # 	departments.
  # end
end
