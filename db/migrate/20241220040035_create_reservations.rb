class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :available_date
      t.time :available_start_time
      t.time :available_end_time
      t.integer :total_slots_count, default: 0
      t.integer :confirmed_slots_count, default: 0
      t.timestamps
    end
  end
end
