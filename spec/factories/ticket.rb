FactoryBot.define do
  factory :ticket do
    sequence(:sb_bet_id)
    wager_date DateTime.now
    wager_type "Straight Wager"
    amount_wagered 10.0
    amount_to_win 9.09

    trait :pending do
      outcome nil
    end

    trait :won do
      outcome "won"
      amount_paid 19.09
    end

    trait :lost do
      outcome "lost"
    end

    trait :push do
      outcome "no action"
    end

    trait :cashed_out do
      outcome "cashed_out"
    end
  end
end
