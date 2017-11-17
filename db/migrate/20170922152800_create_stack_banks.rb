class CreateStackBanks < ActiveRecord::Migration
  def change
    create_table :stack_banks do |t|
      t.string :name
      t.string :cod

      t.timestamps null: false
    end
  end
end
