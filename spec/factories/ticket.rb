FactoryBot.define do
  factory :ticket do
    sequence(:sb_bet_id)
    wager_date "2015-09-03 17:06:00"
    wager_type "Straight Wager"
    amount_wagered 10.0
    amount_to_win 9.09

    trait :pending do
      outcome "pending"
    end

    trait :won do
      outcome "won"
      amount_paid 19.09
    end

    trait :lost do
      outcome "lost"
    end

    trait :cashed_out do
      outcome "cashed_out"
    end
  end
end
