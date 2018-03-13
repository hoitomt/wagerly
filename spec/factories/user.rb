FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "bart_simpson_#{n}@example.com"
    end

    first_name "Bart"
    last_name "Simpson"
    password "EatMyShorts"
    password_confirmation "EatMyShorts"
  end
end
