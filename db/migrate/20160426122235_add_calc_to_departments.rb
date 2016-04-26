class AddCalcToDepartments < ActiveRecord::Migration
  def change
  	add_column :departments, :income_current, :decimal
	add_column :departments, :income_year, :decimal
	add_column :departments, :income_q1, :decimal
	add_column :departments, :income_q2, :decimal
	add_column :departments, :income_q3, :decimal
	add_column :departments, :income_q4, :decimal
	add_column :departments, :scale_current, :decimal
	add_column :departments, :channel_income_current, :decimal
	add_column :departments, :channel_income_year, :decimal
	add_column :departments, :channel_income_q1, :decimal
	add_column :departments, :channel_income_q2, :decimal
	add_column :departments, :channel_income_q3, :decimal
	add_column :departments, :channel_income_q4, :decimal
	add_column :departments, :channel_scale_current, :decimal
  end
end
