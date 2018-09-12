class Client < ApplicationRecord
  belongs_to :user

  has_many :ticket_tags, dependent: :destroy
  has_many :tickets, through: :ticket_tags
  has_many :transactions

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
