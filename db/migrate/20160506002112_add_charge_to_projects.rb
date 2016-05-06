class AddChargeToProjects < ActiveRecord::Migration
  def change
	add_column :projects, :charge_type, :string  #收费模式   普通|前端收费|后端收费
	add_column :projects, :charge_amount, :decimal, default: 0.0 #规模金额
	add_column :projects, :charge_date, :date #收费日期
  end
end
