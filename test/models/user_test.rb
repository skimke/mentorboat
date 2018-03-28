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

  test '.pending_approval returns users with is_approved set to false and is_admin is false' do
    user1 = create(:user, is_approved: false)
    user2 = create(:user, is_approved: true)
    user3 = create(:user, :admin, is_approved: false)

    assert_includes User.pending_approval, user1
    refute_includes User.pending_approval, user2
    refute_includes User.pending_approval, user3
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

  test '#mentors returns all mentee users associated with user through mentoring_relationship' do
    mentor = create(:user, :mentor)
    mentee = create(:user, :mentee)
    relationship = create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
    )

    assert_includes mentee.mentors, mentor
    assert_empty mentor.mentors
  end

  test '#mentees returns all mentor users associated with user through mentored_relationship' do
    mentor = create(:user, :mentor)
    mentee = create(:user, :mentee)
    create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
    )

    assert_includes mentor.mentees, mentee
    assert_empty mentee.mentees
  end

  test '#mentoring_cohorts returns all cohorts associated through mentoring relationships' do
    mentor = create(:user, :mentor)
    mentee = create(:user, :mentee)
    cohort = create(:cohort)

    create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
      cohort_id: cohort.id
    )

    assert_includes mentor.mentoring_cohorts, cohort
  end

  test '#mentored_cohorts returns all cohorts associated through mentored relationships' do
    mentor = create(:user, :mentor)
    mentee = create(:user, :mentee)
    cohort = create(:cohort)

    create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
      cohort_id: cohort.id
    )

    assert_includes mentee.mentored_cohorts, cohort
  end
end
