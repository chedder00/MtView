class Role < ActiveRecord::Base

  has_many :users, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: true
  validates :level, presence: true, uniqueness: true

end
