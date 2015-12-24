require 'ostruct'

class Clone < OpenStruct

  include ActiveModel::Validations
  
  validates :clone_date, presence: true
  validates :clone_qty, presence: true, numericality: 
                                        { greater_than: 0,
                                          less_than_or_equal_to: 50 }

end