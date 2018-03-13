FactoryBot.define do
  factory :ticket_tag do
    ticket
    client
    amount 5
  end
end
