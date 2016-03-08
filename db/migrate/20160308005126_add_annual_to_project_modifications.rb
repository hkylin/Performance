class AddAnnualToProjectModifications < ActiveRecord::Migration
  def change
    add_column :project_modifications, :annual, :integer
  end
end
