class TicketTag < ApplicationRecord
  belongs_to :ticket
  belongs_to :client

  def tag_name
    self.client.present? ? self.client.full_name : ""
  end
end
