FactoryBot.define do
  factory :user do
    name "Hermione Granger"
    position "CEO"
    company "League of Witches"
    experience_in_years 6
    email "herms@gmail.com"

    trait :new do
      position nil
      company nil
    end
  end
end
