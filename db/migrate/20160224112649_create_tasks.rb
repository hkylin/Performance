class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :year
      t.decimal :amount#规模
      t.decimal :profit#收入
      t.string :taskable_type
      t.integer :taskable_id
      t.timestamps null: false
    end
  end
end
