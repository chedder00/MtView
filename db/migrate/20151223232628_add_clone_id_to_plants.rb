class AddCloneIdToPlants < ActiveRecord::Migration
  def change
    add_reference :plants, :cloned_from, index: true, foreign_key: true
  end
end
