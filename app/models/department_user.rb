class DepartmentUser < ActiveRecord::Base
  belongs_to :department
  belongs_to :user

  #role 
  	#have   不是直属管理树枝、树叶的关系
  	#admin  部门主管
  	#       空代表部门成员
end
