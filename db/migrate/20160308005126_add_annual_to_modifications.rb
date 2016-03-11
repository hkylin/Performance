class AddAnnualToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :annual, :integer
  end
end
