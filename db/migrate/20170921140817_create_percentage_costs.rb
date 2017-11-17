class CreatePercentageCosts < ActiveRecord::Migration
  def change
    create_table :percentage_costs do |t|
      t.string :order_id
      t.float :quantify

      t.timestamps null: false
    end
  end
end
