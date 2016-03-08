class AddRiskToProjectModifications < ActiveRecord::Migration
  def change
    add_column :project_modifications, :risk, :string
  end
end
