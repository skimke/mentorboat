class User < ApplicationRecord
  include Clearance::User

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :experience_in_years, presence: true

  def experience
    experience_in_years
  end
end
