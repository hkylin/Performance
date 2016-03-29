class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
      # t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.decimal :scale #number
      t.date :start_date
      t.date :end_date
      t.string :charge_type #收费模式   普通|前端收费|后端收费
      t.decimal :charge_amount #规模金额
      t.string :investment_manager
      t.decimal :management_fee
      t.decimal :rate
      t.decimal :fee
      t.text :notes

      t.string :modificationable_type
      t.integer :modificationable_id

      t.timestamps null: false
    end
  end
end
