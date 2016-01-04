class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :message
      t.references :plant, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :inventory_item, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :notes, [:plant_id, :updated_at]
    add_index :notes, [:user_id, :updated_at]
    add_index :notes, [:inventory_item_id, :updated_at]
  end
end
