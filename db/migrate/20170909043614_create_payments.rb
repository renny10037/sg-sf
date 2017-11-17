class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :asignation_id
      t.float :quantify
      t.text :description
      t.string :user_id

      t.timestamps null: false
    end
  end
end
