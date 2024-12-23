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

ActiveRecord::Schema[7.1].define(version: 2024_12_21_044108) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exam_reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exam_schedule_id", null: false
    t.boolean "is_confirmed", default: false
    t.datetime "confirmed_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_exam_reservations_on_created_at"
    t.index ["deleted_at"], name: "index_exam_reservations_on_deleted_at"
    t.index ["exam_schedule_id"], name: "index_exam_reservations_on_exam_schedule_id"
    t.index ["user_id", "exam_schedule_id"], name: "index_exam_reservations_on_user_id_and_exam_schedule_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["user_id"], name: "index_exam_reservations_on_user_id"
  end

  create_table "exam_schedules", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.integer "total_slots_count", default: 0
    t.integer "confirmed_slots_count", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_exam_schedules_on_created_at"
    t.index ["date", "start_time", "end_time"], name: "index_exam_schedules_on_date_and_start_time_and_end_time", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_exam_schedules_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.string "password_digest"
    t.integer "user_level", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "exam_reservations", "exam_schedules"
  add_foreign_key "exam_reservations", "users"
end
