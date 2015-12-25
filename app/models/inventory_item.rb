class InventoryItem < ActiveRecord::Base

attr_accessor :price, :increase_qty

MARKUP = 0.12

validates :name, presence: true, length: { maximum: 100 }

validates :quantity, :increase_qty, numericality: { greater_than_or_equal_to: 0 }

validates :price, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, 
                  numericality: { greater_than_or_equal_to: 0.00, 
                                  less_than_or_equal_to: 999999.99 }

validates :price_cents, format: { with: /\A\d+\z/ }, 
                  numericality: { greater_than_or_equal_to: 0, 
                                  less_than_or_equal_to: 99999999 }

  def increase_qty
    0
  end

  def increase_qty=(new_qty)
    self.quantity += new_qty.to_i
  end

  def price
    (price_cents.to_f / 100).round(2)
  end

  def price=(new_price)
    self.price_cents = ((new_price.is_a? String) ? 
        new_price.scan(/[.0-9]/).join.to_f : new_price) * 100
    if avaliable_to_reseller?
      self.suggested_retail_price_cents = 
                      (price_cents + (price_cents * MARKUP)).ceil
    end
  end

end
