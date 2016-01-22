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

ActiveRecord::Schema.define(version: 20160114044732) do

  create_table "inventory_items", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity",                        default: 0
    t.boolean  "avaliable_to_reseller",           default: false
    t.integer  "price_cents",                     default: 0,     null: false
    t.string   "price_currency",                  default: "USD", null: false
    t.integer  "suggested_retail_price_cents",    default: 0,     null: false
    t.string   "suggested_retail_price_currency", default: "USD", null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "inventory_items", ["name"], name: "index_inventory_items_on_name"

  create_table "items", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "inventory_item_id"
    t.integer  "quantity",             default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "order_id"
    t.integer  "purchase_price_cents", default: 0
  end

  add_index "items", ["inventory_item_id"], name: "index_items_on_inventory_item_id"
  add_index "items", ["order_id", "inventory_item_id"], name: "index_items_on_order_id_and_inventory_item_id"
  add_index "items", ["order_id"], name: "index_items_on_order_id"
  add_index "items", ["task_id", "inventory_item_id"], name: "index_items_on_task_id_and_inventory_item_id"
  add_index "items", ["task_id"], name: "index_items_on_task_id"

  create_table "measurements", force: :cascade do |t|
    t.float    "base",       default: 0.0
    t.float    "height",     default: 0.0
    t.integer  "plant_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "measurements", ["plant_id"], name: "index_measurements_on_plant_id"

  create_table "notes", force: :cascade do |t|
    t.text     "message"
    t.integer  "plant_id"
    t.integer  "user_id"
    t.integer  "inventory_item_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "closed",            default: false
  end

  add_index "notes", ["inventory_item_id", "updated_at"], name: "index_notes_on_inventory_item_id_and_updated_at"
  add_index "notes", ["inventory_item_id"], name: "index_notes_on_inventory_item_id"
  add_index "notes", ["plant_id", "updated_at"], name: "index_notes_on_plant_id_and_updated_at"
  add_index "notes", ["plant_id"], name: "index_notes_on_plant_id"
  add_index "notes", ["user_id", "updated_at"], name: "index_notes_on_user_id_and_updated_at"
  add_index "notes", ["user_id"], name: "index_notes_on_user_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "total_cents",    default: 0,     null: false
    t.string   "total_currency", default: "USD", null: false
    t.boolean  "completed",      default: false
    t.boolean  "submitted",      default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

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
    t.string   "serial_number"
  end

  add_index "plants", ["plant_state_id"], name: "index_plants_on_plant_state_id"
  add_index "plants", ["serial_number"], name: "index_plants_on_serial_number"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["level"], name: "index_roles_on_level", unique: true
  add_index "roles", ["name"], name: "index_roles_on_name", unique: true

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "states", ["abbr"], name: "index_states_on_abbr"

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "plant_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tasks", ["plant_id", "updated_at"], name: "index_tasks_on_plant_id_and_updated_at"
  add_index "tasks", ["plant_id"], name: "index_tasks_on_plant_id"
  add_index "tasks", ["user_id", "updated_at"], name: "index_tasks_on_user_id_and_updated_at"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

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

end
