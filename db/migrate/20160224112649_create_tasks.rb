class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :task_type
      t.decimal :amount#规模
      
      t.date :start_date 
      t.date :end_date   
      
      t.text :description
      t.string :taskable_type
      t.integer :taskable_id
      t.timestamps null: false
    end
  end
end
