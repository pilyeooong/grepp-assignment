class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :nickname
      t.string :password_digest
      t.integer :user_level, default: 0
      t.datetime :deleted_at, index: true
      t.timestamps
    end

    add_index :users, :email, unique: true, where: 'deleted_at IS NULL'
  end
end
