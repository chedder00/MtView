class AddIndexToPlantStatesLevel < ActiveRecord::Migration
  def change
    add_index :plant_states, :state, unique: true
    add_index :plant_states, :level, unique: true
  end
end
