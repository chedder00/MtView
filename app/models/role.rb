class Role < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: true
  validates :level, presence: true, uniqueness: true

end
