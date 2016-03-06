class AddRoleToDepartmentUsers < ActiveRecord::Migration
  def change
  	add_column :department_users, :role, :string
  end
end
