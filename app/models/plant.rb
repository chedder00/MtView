class Plant < ActiveRecord::Base

  after_save :set_serial_number

  has_many :tasks, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
  validates :planting_date, presence: true
  validates :plant_state_id, presence: true

################## PRIVATE METHODS #############################################
private
  def set_serial_number
    if(self.serial_number.nil?)
      sn = (name[0..2].upcase + planting_date.strftime("%m%d%y") + id.to_s)
      update_column(:serial_number, sn)
    end
  end

end
