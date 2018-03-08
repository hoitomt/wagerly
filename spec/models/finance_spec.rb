require 'rails_helper'

RSpec.describe Finance, type: :model do
  let(:client_1) { create :client }
  let(:client_2) { create :client, first_name: 'Marge', last_name: 'Simpson' }

  let(:won_ticket_1) { create :ticket, :won, amount_wagered: 10, amount_to_win: 9.00, amount_paid: 19.00 }
  let(:won_ticket_1_tag_1) { create :ticket_tag, ticket: won_ticket_1, client: client_1, amount: 5 }
  let(:won_ticket_1_tag_2) { create :ticket_tag, ticket: won_ticket_1, client: client_2, amount: 5 }

  let(:won_ticket_2) { create :ticket, :won, amount_wagered: 2, amount_to_win: 14, amount_paid: 16.00 }
  let(:won_ticket_2_tag_1) { create :ticket_tag, ticket: won_ticket_2, client: client_1, amount: 1 }
  let(:won_ticket_2_tag_2) { create :ticket_tag, ticket: won_ticket_2, client: client_2, amount: 1 }

  let(:lost_ticket_1) { create :ticket, :lost, amount_wagered: 2, amount_to_win: 14 }
  let(:lost_ticket_1_tag_1) { create :ticket_tag, ticket: lost_ticket_1, client: client_1, amount: 1 }
  let(:lost_ticket_1_tag_2) { create :ticket_tag, ticket: lost_ticket_1, client: client_2, amount: 1 }

  let(:lost_ticket_2) { create :ticket, :lost, amount_wagered: 20, amount_to_win: 14 }
  let(:lost_ticket_2_tag_1) { create :ticket_tag, ticket: lost_ticket_2, client: client_1, amount: 20 }

  # Total Wagered - All Clients (sum ticket.amount_wagered): 34
  # Total Wagered Client 1: 27
  # Total Wagered Client 2: 7

  # Total Won - All Clients (sum ticket.amount_paid): 35
  # Total Won Client 1: 17.50
  # Total Wone Client 2: 17.50


end
