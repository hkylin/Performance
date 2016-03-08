class AddAnnualToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :annual, :integer  #计算年华收益的基准  365|360
  end
end
