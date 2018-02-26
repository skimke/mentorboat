require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:email).allow_blank
  should validate_presence_of(:experience_in_years)

  setup do
    @user = build_stubbed(:user)
  end

  test '#experience returns experience_in_years' do
    expected = @user.experience_in_years
    assert_equal expected, @user.experience
  end
end
