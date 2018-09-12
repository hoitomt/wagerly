class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :client_id
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
