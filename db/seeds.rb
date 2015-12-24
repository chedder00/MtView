# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create!(name: "Reseller", level: 0)
Role.create!(name: "Regular Employee", level: 1)
Role.create!(name: "Inventory Controller", level: 5)
Role.create!(name: "Administrator", level: 10)
controller = Role.create!(name: "Controller", level: 15)

User.create!( name: "Root User",
              email: "root@user.com",
              role_id: controller.id,
              password: "Password1",
              password_confirmation: "Password1" )

PlantState.create!(name: "Cloning")
PlantState.create!(name: "Veg")
PlantState.create!(name: "Bloom")
PlantState.create!(name: "Harvest")
PlantState.create!(name: "Mother")