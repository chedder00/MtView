class PlantState < ActiveRecord::Base
  validates :state, presence: true
  validates :level, presence: true

end
