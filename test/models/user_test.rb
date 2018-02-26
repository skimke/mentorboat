require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should validate_presence_of(:experience_in_years)
end
