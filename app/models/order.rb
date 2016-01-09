class Order < ActiveRecord::Base
  
  attr_accessor :update_total

  belongs_to :user

  has_many :items, dependent: :destroy

  validates :user_id, presence: true
  
  monetize :total_cents

  def update_total=(val)
    self.total_cents += val.to_i
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

  end

end
