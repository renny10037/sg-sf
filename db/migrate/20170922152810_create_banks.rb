class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :stack_bank_id
      t.string :type_account
      t.string :cod
      t.string :n_account
      t.string :email_paypal
      t.string :user_id

      t.timestamps null: false
    end
  end
end
