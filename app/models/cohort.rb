class Cohort < ApplicationRecord
  has_many :relationships
  has_many :mentors, through: :relationships, foreign_key: 'mentor_id', class_name: 'User'
  has_many :mentees, through: :relationships, foreign_key: 'mentee_id', class_name: 'User'

  validates :starts_at, presence: true
  validates :ends_at, presence: true

  before_save :ensure_ends_at_end_of_day

  paginates_per 10

  default_scope { order(starts_at: :asc, name: :asc) }

  scope :by_id_and_user_id, ->(id, user_id) {
    joins(:relationships)
    .where(
      'relationships.mentor_id = ? OR relationships.mentee_id = ?',
      user_id,
      user_id
    ).where('cohorts.id = ?', id)
  }

  private

  def ensure_ends_at_end_of_day
    ends_at_end_of_day = self.ends_at.end_of_day
    self.ends_at = ends_at_end_of_day
  end
end
