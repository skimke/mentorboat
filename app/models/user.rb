class User < ApplicationRecord
  include Clearance::User

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :experience_in_years, presence: true

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
