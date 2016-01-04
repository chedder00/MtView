class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float :base, default: 0.000
      t.float :height, default: 0.000
      t.references :plant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
