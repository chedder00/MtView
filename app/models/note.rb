class Note < ActiveRecord::Base
  belongs_to :plant
  belongs_to :user
  belongs_to :inventory_item
  
  default_scope { where(closed: false) }
  default_scope { order('updated_at DESC') }

  validates :message, presence: true
end
