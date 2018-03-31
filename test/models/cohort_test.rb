require 'test_helper'

class CohortTest < ActiveSupport::TestCase
  should validate_presence_of(:starts_at)
  should validate_presence_of(:ends_at)

  setup do
    @mentor = create(:user, :mentor)
    @mentee = create(:user, :mentee)
    @cohort = create(:cohort)
    
    @relationship = create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
      cohort_id: cohort.id,
    )
  end

  test '.by_id_and_user_id returns the cohort if user id is present for an associated relationship with a cohort and the cohort id matches' do
    user = create(:user, :mentor)
    expected_cohort = create(:cohort, :spring)
    excluded_cohort = create(:cohort, :summer)

    create(
      :relationship,
      mentor: user,
      mentee: create(:user),
      cohort: expected_cohort
    )

    assert_includes Cohort.by_id_and_user_id(expected_cohort.id, user.id), expected_cohort
  end

  test '.by_id_and_user_id returns nothing if user id is present for an associated relationship with a cohort but the cohort id does not match' do
    user = create(:user, :mentor)
    expected_cohort = create(:cohort, :spring)
    excluded_cohort = create(:cohort, :summer)

    create(
      :relationship,
      mentor: user,
      mentee: create(:user),
      cohort: expected_cohort
    )

    assert_empty Cohort.by_id_and_user_id(excluded_cohort.id, user.id)
  end

  test '.by_id_and_user_id returns nothing if user id is not present for an associated relationship with a cohort' do
    user = create(:user, :mentor)
    cohort = create(:cohort, :spring)

    assert_empty Cohort.by_id_and_user_id(cohort.id, user.id)
  end

  test 'update ensures ends_at is set to end of day specified' do
    cohort = create(:cohort, :spring)
    expected_date = Date.new(2018, 6, 30)
    cohort.ends_at = expected_date

    cohort.save!

    assert_in_delta expected_date.end_of_day, cohort.reload.ends_at, 1.second
  end

  test '#mentors returns all mentoring users' do
    assert_includes cohort.mentors, mentor
    refute_includes cohort.mentors, mentee
  end

  test '#mentees returns all mentored users' do
    assert_includes cohort.mentees, mentee
    refute_includes cohort.mentees, mentor
  end

  private

  attr_reader :mentor, :mentee, :cohort
end
