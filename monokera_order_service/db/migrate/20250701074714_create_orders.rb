class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :status
      t.decimal :total

      t.timestamps
    end
  end
end
