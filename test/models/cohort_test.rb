require 'test_helper'

class CohortTest < ActiveSupport::TestCase
  should validate_presence_of(:starts_at)
  should validate_presence_of(:ends_at)
end
