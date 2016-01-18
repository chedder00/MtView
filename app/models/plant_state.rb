class PlantState < ActiveRecord::Base

  has_many :plants

  validates :name, presence: true, length: { maximum: 255 }

end
