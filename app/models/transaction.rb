class Transaction < ApplicationRecord
  belongs_to :client

  # Needed to support the UI
  attr_accessor :deposit, :withdrawal
end
