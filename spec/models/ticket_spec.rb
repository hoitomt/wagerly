require 'rails_helper'

RSpec.describe Ticket, type: :model do

  describe "team bet pending" do
    let(:ticket){ create :ticket, :pending }

    before do
      TicketLineItem.create(ticket_id: ticket.id,
        away_team: "Memphis Grizzlies",
        away_score: 51,
        home_team: "Philadelphia 76ers",
        home_score: 63,
        line_item_date: "2018-03-22 00:10:00",
        line_item_spread: "Philadelphia 76ers -12 (-110)",
        description: "Philadelphia 76ers -12 (-110)"
      )
    end

    it 'description' do
      expect(ticket.reload.description).to eq(["Memphis Grizzlies at Philadelphia 76ers (Philadelphia 76ers -12 (-110))"])
    end
  end

  describe "future bet pending" do
    let(:ticket){ create :ticket, :pending }

    before do
      TicketLineItem.create(ticket_id: ticket.id,
        away_team: "Kansas St",
        away_score: nil,
        home_team: "",
        home_score: nil,
        line_item_date: "2018-03-25 02:00:00",
        line_item_spread: "17/4",
        description: "2018 Mens NCAA Basketball South Region - Odds to Win | Kansas St | 17/4"
      )
    end

    it 'description' do
      expect(ticket.reload.description).to eq(["2018 Mens NCAA Basketball South Region - Odds to Win | Kansas St | 17/4"])
    end
  end

  describe "team bet complete" do
    let(:ticket){ create :ticket, :won }

    before do
      TicketLineItem.create(ticket_id: ticket.id,
        away_team: "Dallas Mavericks",
        away_score: 105,
        home_team: "New Orleans Pelicans",
        home_score: 115,
        line_item_date: "2018-03-21 01:10:00",
        line_item_spread: "New Orleans Pelicans -9 (-110)",
        description: "New Orleans Pelicans -9 (-110)"
      )
    end

    it 'description' do
      expect(ticket.reload.description).to eq(["Dallas Mavericks 105 at New Orleans Pelicans 115 (New Orleans Pelicans -9 (-110))"])
    end
  end

  describe "future bet complete" do
    let(:ticket){ create :ticket, :lost }
    before do
      TicketLineItem.create(ticket_id: ticket.id,
        away_team: "Tie HT / Eagles FT",
        away_score: 0,
        home_team: "",
        home_score: nil,
        line_item_date: "2018-02-05 00:30:00",
        line_item_spread: "20/1",
        description: "Eagles vs Patriots - Double Result | Tie HT / Eagles FT | 20/1"
      )
    end

    it 'description' do
      expect(ticket.reload.description).to eq(["Eagles vs Patriots - Double Result | Tie HT / Eagles FT | 20/1"])
    end
  end
end
