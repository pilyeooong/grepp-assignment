class CreateUserReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :user_reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true
      t.boolean :is_confirmed, default: false
      t.timestamps
    end

    add_index :user_reservations, [:user_id, :reservation_id], unique: true
  end
end
