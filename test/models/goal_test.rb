require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
end
