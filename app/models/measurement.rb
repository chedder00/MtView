class Measurement < ActiveRecord::Base
  belongs_to :plant

  validates :base, :height, format: { with: /\A\d+(?:\.\d{0,3})?\z/ }, 
                    numericality: { greater_than_or_equal_to: 0.000, 
                                  less_than_or_equal_to: 99999.99 }
end
