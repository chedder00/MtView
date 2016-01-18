class AddIndexOnSerialNumberToPlants < ActiveRecord::Migration
  def change
    add_index :plants, :serial_number
  end
end
