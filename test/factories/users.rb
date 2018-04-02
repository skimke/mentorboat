FactoryBot.define do
  factory :user do
    first_name "Hermione"
    last_name "Granger"
    position "CEO"
    company "League of Witches"
    experience_in_years 6
    sequence(:email) { |n| "herms+#{n}@gmail.com" }
    password 1234

    trait :new do
      position nil
      company nil
    end

    trait :admin do
      is_admin true
    end

    trait :mentor do
      willing_to_mentor true
      experience_in_years 999
    end

    trait :mentee do
      willing_to_mentor false
      experience_in_years 1
    end
  end
end
