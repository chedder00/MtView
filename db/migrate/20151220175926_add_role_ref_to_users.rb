class AddRoleRefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer, index: true, foreign_key: true
  end
end
