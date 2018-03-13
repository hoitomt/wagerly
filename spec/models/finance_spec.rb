require 'rails_helper'

RSpec.describe Finance, type: :model do
  let(:client) { create :client }
  let(:start_date) { DateTime.now.beginning_of_year }
  let(:stop_date) { DateTime.now.end_of_year }
  subject{ Finance.new(client, start_date, stop_date) }

  let!(:client_2) { create :client, first_name: 'Marge', last_name: 'Simpson' }

  before do
    won_ticket_1 = create :ticket, :won, amount_wagered: 10, amount_to_win: 9.00, amount_paid: 19.00
    create :ticket_tag, ticket: won_ticket_1, client: client, amount: 5
    create :ticket_tag, ticket: won_ticket_1, client: client_2, amount: 5

    won_ticket_2 = create :ticket, :won, amount_wagered: 2, amount_to_win: 14, amount_paid: 16.00
    create :ticket_tag, ticket: won_ticket_2, client: client, amount: 1
    create :ticket_tag, ticket: won_ticket_2, client: client_2, amount: 1

    lost_ticket_1 = create :ticket, :lost, amount_wagered: 2, amount_to_win: 14
    create :ticket_tag, ticket: lost_ticket_1, client: client, amount: 1
    create :ticket_tag, ticket: lost_ticket_1, client: client_2, amount: 1

    lost_ticket_2 = create :ticket, :lost, amount_wagered: 20, amount_to_win: 14
    create :ticket_tag, ticket: lost_ticket_2, client: client, amount: 20

    pending_ticket_1 = create :ticket, :pending, amount_wagered: 16, amount_to_win: 14
    create :ticket_tag, ticket: pending_ticket_1, client: client, amount: 8
    create :ticket_tag, ticket: pending_ticket_1, client: client_2, amount: 8
  end

  describe 'amount_won' do
    it 'by client' do
      expect(subject.amount_won).to eq 17.50
    end
  end

  describe 'amount_wagered' do
    it 'by client' do
      expect(subject.amount_wagered).to eq 35
    end
  end

  describe 'amount lost' do
    it 'by client' do
      expect(subject.amount_lost).to eq 9.50
    end
  end

  describe 'amount pending' do
    it 'by client' do
      expect(subject.amount_pending).to eq 8
    end
  end

  describe 'summary' do
    it 'by client' do
      expect(subject.summary).to eq -17.50
    end
  end

end
