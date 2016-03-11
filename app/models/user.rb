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
  has_many :project_modifications
  has_many :cooperations

  ROLES = %i[super_admin admin staff]

  
  #has_many :department_users
  def name
    username
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

def count_management_fee_tasks_between(start_date, end_date)  
  count_management_fee_tasks*(Date.new(end_date)-Date.new(start_date))/365
end
# scale management_fee profit

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

def count_tasks(task_type)#TODO 任务指标  目前只做了 管理费  ，这是一个必须修改的地方  
  scale = 0.0;
  tasks.each do |task|
    scale += task.amount if task.task_type == task_type
  end
  scale
end 

def count_scale(at_date)
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

def count_fee_between(startd,endd)  #计算个人的计划与项目的管理费
    sum=0.0
    plans.each do |plan|
      sum = sum + plan.count_fee_between(startd,endd)
    end
    projects.each do |project|
      sum = sum + project.count_fee_between(startd,endd)
    end
    sum
end

def count_fee(between_date)  #计算个人的计划与项目的管理费
    startd=between_date[0]
    endd=between_date[1]
    count_fee_between(startd,endd)
end
  # def sonUser
  # 	Array.new 
  # 	departments.
  # end
end
