class AddPurchasePriceToItem < ActiveRecord::Migration
  def change
    add_column :items, :purchase_price_cents, :integer, default: 0
  end
end
