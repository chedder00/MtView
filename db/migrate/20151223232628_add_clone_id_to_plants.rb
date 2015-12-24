class AddCloneIdToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :cloned_from_id, :integer, index: true, foreign_key: true
  end
end
