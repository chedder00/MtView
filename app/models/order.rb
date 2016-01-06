class Order < ActiveRecord::Base
  belongs_to :user

  has_many :items, dependent: :destroy

  validates :user_id, presence: true
  
  monetize :total_cents

  class << self
    
    def open
      where(completed: false)
    end

  end
  
end
