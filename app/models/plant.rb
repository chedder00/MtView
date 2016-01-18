class Plant < ActiveRecord::Base

  attr_reader :plant_state_name

  has_many :tasks, dependent: :nullify
  has_many :notes, dependent: :nullify
  has_many :measurements, dependent: :destroy
  belongs_to :plant_state

  after_save :set_serial_number

  validates :name, presence: true, length: { maximum: 50 }
  validates :planting_date, presence: true
  validates :plant_state_id, presence: true

  def plant_state_name
    plant_state.name
  end

  class << self
    
    def state
      order('plant_state_id')
    end

    def scoped(id=nil)
      if(id)
        where(id: id)
      else
        state
      end
    end

  end

################## PRIVATE METHODS #############################################
private
  def set_serial_number
    if(self.serial_number.nil?)
      sn = (name[0..2].upcase + planting_date.strftime("%m%d%y") + id.to_s)
      update_column(:serial_number, sn)
    end
  end

end
