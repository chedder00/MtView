class AddPurchasePriceToItem < ActiveRecord::Migration
  def change
    add_column :items, :purchase_price_cents, :monetize, default: 0
  end
end
