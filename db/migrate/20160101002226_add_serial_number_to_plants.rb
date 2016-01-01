class AddSerialNumberToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :serial_number, :string
  end
end
