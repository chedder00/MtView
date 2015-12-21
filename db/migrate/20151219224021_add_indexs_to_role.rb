class AddIndexsToRole < ActiveRecord::Migration
  def change
    add_index :roles, :name, unique: true
    add_index :roles, :level, unique: true
  end
end
