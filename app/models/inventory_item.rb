class InventoryItem < ActiveRecord::Base

has_many :notes, dependent: :nullify
has_many :items, dependent: :nullify

attr_accessor :new_price, :increase_qty

MARKUP = 0.12

validates :name, presence: true, length: { maximum: 100 }

validates :quantity, :increase_qty, numericality: { greater_than_or_equal_to: 0 }

validates :price, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, 
                  numericality: { greater_than_or_equal_to: 0.00, 
                                  less_than_or_equal_to: 999999.99 }

validates :price_cents, format: { with: /\A\d+\z/ }, 
                  numericality: { greater_than_or_equal_to: 0, 
                                  less_than_or_equal_to: 99999999 }

monetize :price_cents
monetize :suggested_retail_price_cents

  def increase_qty
    0
  end

  def increase_qty=(new_qty)
    self.quantity += new_qty.to_i
  end

  def new_price
    (price_cents.to_f / 100).round(2)
  end

  def new_price=(_price)
    self.price_cents = ((_price.is_a? String) ? 
        _price.scan(/[.0-9]/).join.to_f : _price) * 100
    if avaliable_to_reseller?
      self.suggested_retail_price_cents = 
                      (price_cents + (price_cents * MARKUP)).ceil
    end
  end

  class << self
    def open
      where(closed: false)
    end

    def resale
      where(avaliable_to_reseller: true)
    end
  end

end
