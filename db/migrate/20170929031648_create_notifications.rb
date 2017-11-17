class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :user
      t.string :asignation
      t.string :description
      t.string :state
      t.string :payment
      t.string :money
      t.string :quantify_payment

      t.timestamps null: false
    end
  end
end
