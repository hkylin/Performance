class AddCalcToPlans < ActiveRecord::Migration
  def change
  	add_column :plans, :m_whole_fee, :decimal
	add_column :plans, :m_year_fee, :decimal
    add_column :plans, :m_scale, :decimal   
    add_column :plans, :mm_scale, :decimal
  end
end
