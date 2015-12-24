class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.string :species
      t.datetime :planting_date
      t.datetime :harvest_date
      t.references :plant_state, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
