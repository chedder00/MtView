# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151223232628) do

  create_table "plant_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plant_states", ["name"], name: "index_plant_states_on_name"

  create_table "plants", force: :cascade do |t|
    t.string   "name"
    t.string   "species"
    t.datetime "planting_date"
    t.datetime "harvest_date"
    t.integer  "plant_state_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "cloned_from_id"
  end

  add_index "plants", ["cloned_from_id"], name: "index_plants_on_cloned_from_id"
  add_index "plants", ["plant_state_id"], name: "index_plants_on_plant_state_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["level"], name: "index_roles_on_level", unique: true
  add_index "roles", ["name"], name: "index_roles_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.date     "hire_date"
    t.date     "termination_date"
    t.boolean  "activated",        default: true
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone_number"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "role_id"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["role_id"], name: "index_users_on_role_id"

end
