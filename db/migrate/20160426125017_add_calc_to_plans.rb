class AddCalcToPlans < ActiveRecord::Migration
  def change
  	add_column :plans, :m_whole_fee, :decimal, default: 0.0
	add_column :plans, :m_year_fee, :decimal, default: 0.0
    add_column :plans, :m_scale, :decimal, default: 0.0
    add_column :plans, :mm_scale, :decimal, default: 0.0
  end
end
