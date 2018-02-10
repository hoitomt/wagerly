class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
