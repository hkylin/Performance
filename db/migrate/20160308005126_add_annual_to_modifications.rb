class AddAnnualToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :annual, :integer,:default => 365
  end
end
