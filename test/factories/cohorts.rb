FactoryBot.define do
  factory :cohort do
    starts_at Time.zone.now + 10.days
    ends_at Time.zone.now + 4.months
  end
end
