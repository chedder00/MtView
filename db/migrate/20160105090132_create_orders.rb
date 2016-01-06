class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.monetize  :total
      t.boolean :completed, default: false
      t.boolean :submitted, default: false

      t.timestamps null: false
    end
  end
end
