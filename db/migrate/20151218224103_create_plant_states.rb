class CreatePlantStates < ActiveRecord::Migration
  def change
    create_table :plant_states do |t|
      t.string :state
      t.integer :level

      t.timestamps null: false
    end
  end
end
