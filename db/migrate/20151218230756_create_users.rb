class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, force: true do |t|
      t.string :name
      t.string :email
      t.date :hire_date
      t.date :termination_date
      t.boolean :activated, default: true
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone_number
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
