# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_12_20_040807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.date "available_date"
    t.time "available_start_time"
    t.time "available_end_time"
    t.integer "total_slots_count", default: 0
    t.integer "confirmed_slots_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "reservation_id", null: false
    t.boolean "is_confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_user_reservations_on_reservation_id"
    t.index ["user_id", "reservation_id"], name: "index_user_reservations_on_user_id_and_reservation_id", unique: true
    t.index ["user_id"], name: "index_user_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.string "password_digest"
    t.integer "user_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_reservations", "reservations"
  add_foreign_key "user_reservations", "users"
end
