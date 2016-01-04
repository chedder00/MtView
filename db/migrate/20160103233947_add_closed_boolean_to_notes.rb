class AddClosedBooleanToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :closed, :boolean, default: false
  end
end
