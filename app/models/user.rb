class User < ApplicationRecord
  include Clearance::User

  has_many :mentored_relationships, class_name: 'Relationship', foreign_key: 'mentee_id'
  has_many :mentoring_relationships, class_name: 'Relationship', foreign_key: 'mentor_id'
  has_many :mentors, -> { distinct }, through: :mentored_relationships
  has_many :mentees, -> { distinct }, through: :mentoring_relationships
  has_many :mentored_cohorts, -> { distinct }, through: :mentored_relationships, source: :cohort
  has_many :mentoring_cohorts, -> { distinct }, through: :mentoring_relationships, source: :cohort
  has_many :goals_as_mentor, through: :mentoring_relationships, source: :goal
  has_many :goals_as_mentee, through: :mentored_relationships, source: :goal
  has_many :feedbacks_as_mentor, through: :mentoring_relationships, source: :feedback
  has_many :feedbacks_as_mentee, through: :mentored_relationships, source: :feedback

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :experience_in_years, presence: true

  paginates_per 20

  default_scope { order(created_at: :desc, first_name: :asc) }

  scope :mentors, -> { where(willing_to_mentor: true) }
  scope :mentees, -> { where(willing_to_mentor: false) }
  scope :pending_approval, -> { where(is_approved: false, is_admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def experience
    experience_in_years
  end

  def requires_details?
    position.nil? || company.nil?
  end

  def cohorts
    [*mentoring_cohorts, *mentored_cohorts].uniq
  end
end
