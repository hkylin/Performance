class AddRiskToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :risk, :string
  end
end
