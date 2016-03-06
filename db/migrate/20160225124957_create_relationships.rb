class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :person, :father, index: true, foreign_key: true
      t.references :person, :son, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end