class Task < ActiveRecord::Base
  
  belongs_to :plant
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :inventory_items, through: :items

  validates :name, presence: true, length: { maximum: 100 }

  class << self
    
    def sorted(direction = "ASC")
      order("updated_at #{direction}")
    end

  end

end
