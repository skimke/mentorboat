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
