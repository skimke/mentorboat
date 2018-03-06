class User < ApplicationRecord
  include Clearance::User

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :experience_in_years, presence: true

  scope :mentors, -> { where(willing_to_mentor: true) }
  scope :mentees, -> { where(willing_to_mentor: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def experience
    experience_in_years
  end

  def requires_details?
    position.nil? || company.nil?
  end
end
