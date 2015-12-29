class Plant < ActiveRecord::Base
 
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
  validates :planting_date, presence: true
  validates :plant_state_id, presence: true
  
end
