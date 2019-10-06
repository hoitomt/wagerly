require 'rails_helper'

describe SB::ParseTickets do
  let(:wager_data){Fixtures.raw_wager_data_2017}
  let(:panel){SB::ParseTickets.result_panels(wager_data).first}
  let(:game){SB::ParseTickets.games(panel).first}
  let(:line_item){SB::ParseTickets.create_line_item(game)}

  describe "all games from page" do
    it "create_tickets" do
      expect {
        SB::ParseTickets.create_tickets(wager_data)
      }.to change(Ticket, :count).by(15)
    end

    it "result_panels" do
      expect(SB::ParseTickets.result_panels(wager_data).length).to eq(15)
    end
  end

  describe "single ticket" do
    let(:wager_data){Fixtures.sb_super_bowl_2017}

    describe 'scraped data elements' do
      it '#sb_wager_date' do
        expect(SB::ParseTickets.sb_wager_date(panel).to_s).to eq("2017-02-05 17:39:00 -0600")
      end

      it '#game_spread' do
        expect(SB::ParseTickets.game_spread(panel)).to eq('Under 127.5 (+120)')
      end

      it "has the correct bet id" do
        expect(SB::ParseTickets.sb_bet_id(panel)).to eq('513711332')
      end

      it "has the correct wager type" do
        expect(SB::ParseTickets.sb_wager_type(panel)).to eq('Straight Wager')
      end

      it "has the correct amount wagered" do
        expect(SB::ParseTickets.sb_amount_wagered(panel)).to eq('2.00')
      end

      it "has the correct amount to win" do
        expect(SB::ParseTickets.sb_amount_to_win(panel)).to eq('2.40')
      end

      it "has the correct outcome" do
        expect(SB::ParseTickets.sb_outcome(panel)).to eq('won')
      end

      it "has the correct amount paid" do
        expect(SB::ParseTickets.sb_amount_paid(panel)).to eq('4.40')
      end
    end

    describe 'Ticket attributes' do
      let(:ticket){SB::ParseTickets.build_ticket(panel)}

      describe 'new' do
        it '#sb_wager_date' do
          expect(ticket.wager_date.to_s).to eq("2017-02-05 23:39:00 UTC")
        end

        it "has the correct bet id" do
          expect(ticket.sb_bet_id).to eq('513711332')
        end

        it "has the correct wager type" do
          expect(ticket.wager_type).to eq('Straight Wager')
        end

        it "has the correct amount wagered" do
          expect(ticket.amount_wagered).to eq(2.00)
        end

        it "has the correct amount to win" do
          expect(ticket.amount_to_win).to eq(2.40)
        end

        it "has the correct outcome" do
          expect(ticket.outcome).to eq('won')
        end

        it "has the correct amount paid" do
          expect(ticket.amount_paid).to eq(4.40)
        end
      end

      describe 'update' do
        before do
          h = {
            wager_date: "2017-02-05 23:39:00 UTC",
            sb_bet_id: '513711332',
            wager_type: 'Straight Wager',
            amount_wagered: 2.00,
            amount_to_win: 2.40,
          }
          Ticket.create(h)
        end

        it "has the correct amount to win" do
          expect(ticket.amount_to_win).to eq(2.40)
        end

        it "has the correct outcome" do
          expect(ticket.outcome).to eq('won')
        end

        it "has the correct amount paid" do
          expect(ticket.amount_paid).to eq(4.40)
        end

      end
    end
  end

  describe "single game" do
    it "has the correct away_team" do
      expect(line_item[:away_team]).to eq('Kansas')
    end

    it "has the the correct home_team" do
      expect(line_item[:home_team]).to eq('Kentucky')
    end

    it "has the correct away_score" do
      expect(line_item[:away_score]).to eq('79')
    end

    it "has the correct home_score" do
      expect(line_item[:home_score]).to eq('73')
    end

    it "has the correct line_item_spread" do
      expect(line_item[:line_item_spread]).to eq('Kansas +7 (-110)')
    end

    it 'has the correct description' do
      expect(line_item[:description]).to eq('Kansas +7 (-110)')
    end
  end

  describe 'Lost Ticket' do
    let(:panel){SB::ParseTickets.result_panels(wager_data)[1]}
    let(:ticket){SB::ParseTickets.build_ticket(panel)}

    it 'has the correct outcome' do
      expect(ticket.outcome).to eq('lost')
    end
  end

  describe 'Pending Ticket' do
    let(:wager_data){Fixtures.sb_pending}
    let(:ticket){SB::ParseTickets.build_ticket(panel)}

    it 'has the correct outcome' do
      expect(ticket.outcome).to be_nil
    end

    it 'has the correct amount_paid' do
      expect(ticket.amount_paid).to be_nil
    end
  end

  describe 'Push Ticket' do
    let(:wager_data){Fixtures.sb_push}
    let(:ticket){SB::ParseTickets.build_ticket(panel)}

    it 'has the correct outcome' do
      expect(ticket.outcome).to eq 'no action'
    end

    it 'has the correct amount_paid' do
      expect(ticket.amount_paid).to eq 5.0
    end
  end

  describe "parlay bet" do
    let(:panel){SB::ParseTickets.result_panels(wager_data)[13]}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}
    let(:ticket){ create :ticket }

    it 'correctly splits a game' do
      expect{
        SB::ParseTickets.create_line_items(panel, ticket)
      }.to change{ TicketLineItem.count }.by(2)
    end
  end

  describe "money line bet" do
    let(:panel){SB::ParseTickets.result_panels(wager_data)[5]}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}

    it "has the correct away_team" do
      expect(line_item[:away_team]).to eq('Houston Texans')
    end

    it "has the the correct home_team" do
      expect(line_item[:home_team]).to eq('New England Patriots')
    end

    it "has the correct away_score" do
      expect(line_item[:away_score]).to eq('16')
    end

    it "has the correct home_score" do
      expect(line_item[:home_score]).to eq('34')
    end

    it "has the correct line_item_spread" do
      expect(line_item[:line_item_spread]).to eq('Houston Texans +900')
    end
  end

  describe 'funky super bowl line - national anthem' do
    let(:wager_data){Fixtures.sb_super_bowl_2017}
    let(:panel){SB::ParseTickets.result_panels(wager_data).first}
    let(:game){SB::ParseTickets.games(panel).first}
    let(:line_item){SB::ParseTickets.create_line_item(game)}

    it 'sets the description' do
      expect(line_item[:description]).to eq "How Long Will it Take Luke Bryan to Sing the US National Anthem (From his first to last note) | Under 127.5 (+120)"
    end

  end

  describe '3 ticket line items' do
    let(:wager_data){Fixtures.sb_response_3_line_items}
    let(:panel){SB::ParseTickets.result_panels(wager_data).first}
    let(:line_items){SB::ParseTickets.games(panel).map{|game| SB::ParseTickets.create_line_item(game)}}

    it "create_tickets" do
      expect {
        SB::ParseTickets.create_tickets(wager_data)
      }.to change(TicketLineItem, :count).by(3)
    end

  end

end
