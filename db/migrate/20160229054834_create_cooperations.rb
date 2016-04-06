class CreateCooperations < ActiveRecord::Migration
  def change
    create_table :cooperations do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :cooperationable_id
      t.string :cooperationable_type

      # t.references :modification, index: true, foreign_key: true
      t.decimal :ratio
      t.string :co_type
      t.timestamps null: false
    end
  end
end
