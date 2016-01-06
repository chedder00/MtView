class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :task, index: true, foreign_key: true
      t.references :inventory_item, index: true, foreign_key: true
      t.integer :quantity, default: 0
      
      t.timestamps null: false
    end
    add_index :items, [:task_id, :inventory_item_id]
  end
end
