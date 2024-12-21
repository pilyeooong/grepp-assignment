class CreateExamSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_schedules do |t|
      t.date :available_date
      t.time :available_start_time
      t.time :available_end_time
      t.integer :total_slots_count
      t.integer :confirmed_slots_count
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
