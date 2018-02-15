class AddClientIdToTicketTags < ActiveRecord::Migration[5.1]
  def change
    add_column :ticket_tags, :client_id, :integer
  end
end
