class Relationship < ApplicationRecord
  belongs_to :mentor, class_name: 'User', optional: true
  belongs_to :mentee, class_name: 'User', optional: true
  belongs_to :cohort, optional: true
  has_many :goals
  has_many :feedbacks

  validate :difference_in_years_of_experience_is_greater_than_1

  private

  def difference_in_years_of_experience_is_greater_than_1
    return unless mentor_id.present? && mentee_id.present?

    if (mentor.experience_in_years - mentee.experience_in_years) <= 0
      errors.add(:base, :mentor_not_experienced_enough_for_mentee)
    end
  end
end
