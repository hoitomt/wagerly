class AddSbInfoToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_sportsbook_username, :string
    add_column :users, :encrypted_sportsbook_username_iv, :string
    add_column :users, :encrypted_sportsbook_password, :string
    add_column :users, :encrypted_sportsbook_password_iv, :string
  end
end
