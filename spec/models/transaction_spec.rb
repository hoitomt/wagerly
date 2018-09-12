require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:client) { create :client }
  let(:start_date) { DateTime.now.beginning_of_year }
  let(:stop_date) { DateTime.now.end_of_year }
  let(:finance) { Finance.new(client, start_date, stop_date) }

  describe 'client financials' do
    let(:amount) { 7.00 }
    let(:transaction) { create :transaction, client: client, amount: amount}

    it 'updates by the transaction amount (simple)' do
      expect(finance.summary).to eq 0
      Transaction.create(client: client, amount: amount)
      expect(finance.reload!.summary).to eq 7.00
    end

    it 'updates by the transaction amount (complex)' do
      ticket1 = create(:ticket, amount_wagered: 15, amount_to_win: 44, outcome: 'won', amount_paid: 59)
      ticket2 = create(:ticket, amount_wagered: 15, amount_to_win: 14, outcome: 'won', amount_paid: 29)
      ticket3 = create(:ticket, amount_wagered: 25, amount_to_win: 22, outcome: 'lost')
      create(:ticket_tag, ticket: ticket1, client: client, amount: 15)
      create(:ticket_tag, ticket: ticket2, client: client, amount: 15)
      create(:ticket_tag, ticket: ticket3, client: client, amount: 25)

      # (59 - 15) + (29 - 15) + (0 - 25) + 7 => 44 + 14 - 25 + 7
      Transaction.create(client: client, amount: amount)
      expect(finance.summary).to eq 40.00

    end
  end
end
