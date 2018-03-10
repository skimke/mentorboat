class Cohort < ApplicationRecord
  has_many :relationships

  validates :starts_at, presence: true
  validates :ends_at, presence: true
end
