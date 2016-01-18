class Order < ActiveRecord::Base
  
  attr_accessor :update_total
  attr_reader :order_number

  belongs_to :user

  has_many :items, dependent: :destroy

  has_many :inventory_items, through: :items

  validates :user_id, presence: true
  
  monetize :total_cents

  def update_total=(val)
    self.total_cents += val.to_i
  end

  def order_number
    self.id.to_s
  end

  class << self
    
    def open
      where(completed: false)
    end

    def current
      open.where(submitted: false)
    end

    def history
      where(submitted: true)
    end

    def closed
      where(completed: true)
    end

  end

end
