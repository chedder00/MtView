class Item < ActiveRecord::Base
  
  attr_accessor :return_quantity

  belongs_to :task
  belongs_to :order
  belongs_to :inventory_item

  before_save :set_purchase_price, on: :create

  validates :quantity, :return_quantity, numericality: { greater_than: 0 },
            allow_nil: true

  monetize :purchase_price_cents

  def return_quantity
    @return_quantity
  end

  def return_quantity=(val)
    @return_quantity = val
  end

  def set_purchase_price
    self.purchase_price_cents = self.inventory_item.price_cents
  end

end
