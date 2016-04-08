class DepartmentUser < ActiveRecord::Base
  belongs_to :department
  belongs_to :user
  ROLE_TYPE = %w(have admin staff)  
  validates_inclusion_of :role, in: ROLE_TYPE
  
  #role 
  	#have   不是直属管理树枝、树叶的关系
  	#admin  部门主管
  	#staff  代表部门成员
end
