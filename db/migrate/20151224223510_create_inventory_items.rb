class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.string :name, index: true, unique: true
      t.integer :quantity, default: 0
      t.boolean :avaliable_to_reseller, default: false
      t.monetize :price, default: 0
      t.monetize :suggested_retail_price, default: 0

      t.timestamps null: false
    end
  end
end
