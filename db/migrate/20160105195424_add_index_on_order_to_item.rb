class AddIndexOnOrderToItem < ActiveRecord::Migration
  def change
    add_index :items, [:order_id, :inventory_item_id]
  end
end
