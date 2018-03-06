require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_uniqueness_of(:email).allow_blank
  should validate_presence_of(:experience_in_years)

  setup do
    @user = create(:user)
  end

  test '.mentors returns users with willing_to_mentor set to true' do
    user1 = create(:user, :mentor)
    user2 = create(:user, :mentee)

    assert_includes User.mentors, user1
    refute_includes User.mentors, user2
  end

  test '.mentees returns users with willing_to_mentor set to false' do
    user1 = create(:user, :mentor)
    user2 = create(:user, :mentee)

    refute_includes User.mentees, user1
    assert_includes User.mentees, user2
  end

  test '#full_name returns first and last name joined with a space' do
    expected = 'Hermione Granger'
    assert_equal expected, @user.full_name
  end

  test '#experience returns experience_in_years' do
    expected = @user.experience_in_years
    assert_equal expected, @user.experience
  end

  test '#requires_details? returns false if position and company are both present' do
    expected = false
    assert_equal expected, @user.requires_details?
  end

  test '#requires_details? returns true if either position or company, or both are nil' do
    expected = true

    @user.update_attributes!(position: nil, company: 'EyeBeeEm')
    assert_equal expected, @user.reload.requires_details?

    @user.update_attributes!(position: 'Devloper', company: nil)
    assert_equal expected, @user.reload.requires_details?

    @user.update_attributes!(position: nil, company: nil)
    assert_equal expected, @user.reload.requires_details?
  end
end
