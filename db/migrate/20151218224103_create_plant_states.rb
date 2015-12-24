class CreatePlantStates < ActiveRecord::Migration
  def change
    create_table :plant_states do |t|
      t.string :name, index: true, unique: true

      t.timestamps null: false
    end
  end
end
