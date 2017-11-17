class CreateAsignations < ActiveRecord::Migration
  def change
    create_table :asignations do |t|
      t.string :order_id
      t.string :phase_id
      t.date :date_start
      t.date :date_end
      t.float :payment
      t.string :user_id
      t.text :description
      t.text :observation
      t.string :state_id
      t.string :admin

      t.timestamps null: false
    end
  end
end
