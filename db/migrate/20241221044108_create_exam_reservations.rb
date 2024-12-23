class CreateExamReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam_schedule, null: false, foreign_key: true
      t.boolean :is_confirmed, default: false
      t.datetime :confirmed_at
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    add_index :exam_reservations, :created_at
    add_index :exam_reservations, [:user_id, :exam_schedule_id], unique: true, where: 'deleted_at IS NULL'
  end
end
