class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :check_in_on,      null: false
      t.date :check_out_on,     null: false
      t.integer :num_of_people, null: false
      t.integer :user_id,       null: false
      t.integer :room_id,       null: false

      t.timestamps
    end
  end
end
