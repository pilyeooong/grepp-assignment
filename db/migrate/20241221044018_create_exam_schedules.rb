class CreateExamSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_schedules do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :total_slots_count, default: 0
      t.integer :confirmed_slots_count, default: 0
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    add_index :exam_schedules, :created_at
    add_index :exam_schedules, [:date, :start_time, :end_time], unique: true, where: 'deleted_at IS NULL'
  end
end
