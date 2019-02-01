require 'spec_helper'

describe SB::ParseBets do
  subject{ described_class }

  let(:wager_data){Fixtures.bets_game_2019}
  # let(:panel){SB::ParseBets.result_panels(wager_data).first}
  # let(:game){SB::ParseBets.games(panel).first}
  # let(:line_item){SB::ParseBets.create_line_item(game)}

  describe "all bets from page" do
    it 'parses bets' do
      ndoc = subject.process(wager_data)
    end

    # it "create_tickets" do
    #   expect {
    #     SB::ParseTickets.create_tickets(wager_data)
    #   }.to change(Ticket, :count).by(15)
    # end

    # it "result_panels" do
    #   expect(SB::ParseTickets.result_panels(wager_data).length).to eq(15)
    # end
  end

end
