class AddRiskToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :risk, :string
  end
end
