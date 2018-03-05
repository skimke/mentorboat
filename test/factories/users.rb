FactoryBot.define do
  factory :user do
    first_name "Hermione"
    last_name "Granger"
    position "CEO"
    company "League of Witches"
    experience_in_years 6
    email "herms@gmail.com"

    trait :new do
      position nil
      company nil
    end

    trait :admin do
      is_admin true
    end
  end
end
