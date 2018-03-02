require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'after_create' do
    let(:user_params) {
      {
        first_name: 'Harry',
        last_name: 'Potter',
        email: 'wizard@hogwarts.edu',
        password: 'phoenixforever',
        password_confirmation: 'phoenixforever'
      }
    }

    it 'creates a client' do
      expect {
        User.create(user_params)
      }.to change{Client.count}.by(1)
    end

    it 'makes the client the same as the user' do
      u = User.create(user_params)
      c = Client.last
      expect(c.first_name).to eq u.first_name
      expect(c.last_name).to eq u.last_name
      expect(c.email).to eq u.email
    end
  end
end
