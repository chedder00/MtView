class Plant < ActiveRecord::Base
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :planting_date, presence: true
  validates :plant_state_id, presence: true
  
end
