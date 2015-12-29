class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :user, index: true, foreign_key: true
      t.references :plant, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :tasks, [:plant_id, :created_at]
  end
end
