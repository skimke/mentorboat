class User < ApplicationRecord
  include Clearance::User

  validates :name, presence: true
  validates :experience_in_years, presence: true

  def experience
    experience_in_years
  end

  def requires_details?
    position.nil? || company.nil?
  end
end
