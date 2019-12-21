class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_encrypted :sportsbook_username, key: Rails.application.credentials.encryption_key
  attr_encrypted :sportsbook_password, key: Rails.application.credentials.encryption_key

  has_many :clients

  after_create :create_self_client

  def create_self_client
    self.clients.create(first_name: self.first_name, last_name: self.last_name, email: self.email)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
