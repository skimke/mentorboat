FactoryBot.define do
  factory :cohort do
    starts_at Time.zone.now + 10.days
    ends_at Time.zone.now + 4.months

    trait :spring do
      starts_at Date.new(2018, 3, 1)
      ends_at Date.new(2018, 5, 1).end_of_day
    end

    trait :summer do
      starts_at Date.new(2018, 6, 1)
      ends_at Date.new(2018, 8, 31).end_of_day
    end

    trait :fall do
      starts_at Date.new(2018, 9, 1)
      ends_at Date.new(2018, 11, 30).end_of_day
    end

    trait :winter do
      starts_at Date.new(2018, 12, 1)
      ends_at Date.new(2018, 2, 28).end_of_day
    end
  end
end
