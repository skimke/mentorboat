class Cohort < ApplicationRecord
  has_many :relationships
  has_many :mentors, through: :relationships, foreign_key: 'mentor_id', class_name: 'User'
  has_many :mentees, through: :relationships, foreign_key: 'mentee_id', class_name: 'User'

  validates :starts_at, presence: true
  validates :ends_at, presence: true

  paginates_per 10

  default_scope { order(starts_at: :asc, name: :asc) }
end
