class Note < ActiveRecord::Base
  attr_reader :date

  belongs_to :plant
  belongs_to :user
  belongs_to :inventory_item
  
  default_scope { where(closed: false) }
  default_scope { order('updated_at DESC') }

  msg_regex = /\<[\>]*\>/i
  validates :message, presence: true, format: { without: msg_regex }

  def date
    self.updated_at.strftime("%m/%d/%Y")
  end

  def display
    "#{date} - #{message}"
  end

  class << self
    
    def scoped(id)
      where("id=?",id)
    end

  end

end
