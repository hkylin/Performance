class AddRiskToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :risk, :string
  end
end
