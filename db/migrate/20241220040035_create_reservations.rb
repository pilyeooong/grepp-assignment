class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :available_date
      t.time :available_start_time
      t.time :available_end_time
      t.timestamps
    end
  end
end
