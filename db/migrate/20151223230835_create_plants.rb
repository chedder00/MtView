class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.string :species
      t.datetime :planting_date
      t.datetime :harvest_date
      t.integer :plant_state_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
