require 'rails_helper'

describe SB::ParseBets do
  subject{ described_class }

  describe 'single game' do
    let(:wager_data){Fixtures.bets_game_2019}

    describe "all bets from page" do
      it 'creates json from the row' do
        ndoc = subject.process(wager_data)
        expect(ndoc.size).to eq 1
        expect(ndoc.first[:heading]).to eq ''
        expect(ndoc.first[:time]).to eq "18:30 EST18:30 EST"
        expect(ndoc.first[:rows].size).to eq 2
        expect(ndoc.first[:rows].first[:row_title]).to eq 'New England Patriots'
      end
    end
  end

  describe 'props' do
    let(:wager_data){Fixtures.bets_props_2019}

    describe "all bets from page" do
      it 'creates json from the row' do
        ndoc = subject.process(wager_data)
        expect(ndoc.size).to eq 71
        expect(ndoc.first[:heading]).to eq 'Super Bowl LIII - Coin Toss'
      end
    end
  end

  describe 'gatorade bath' do
    let(:wager_data){Fixtures.bets_gatorade_bath_2019}

    describe "all bets from page" do
      it 'creates json from the row' do
        ndoc = subject.process(wager_data)
        expect(ndoc.first[:heading]).to eq ''
      end
    end

  end

end
