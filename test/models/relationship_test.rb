require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @mentor = create(:user, :mentor)
    @mentee = create(:user, :mentee)
  end

  test 'cohort is an optional field' do
    assert_nothing_raised do
      create(:relationship, mentor: mentor, mentee: mentee, cohort: nil)
    end
  end

  test 'mentor is an optional field' do
    cohort = create(:cohort)

    assert_nothing_raised do
      create(:relationship, mentor: nil, mentee: mentee, cohort: cohort)
    end
  end

  test 'mentee is an optional field' do
    cohort = create(:cohort)

    assert_nothing_raised do
      create(:relationship, mentor: mentor, mentee: nil, cohort: cohort)
    end
  end

  test 'update pairs mentee with a mentor with at least 1 more year of experience' do
    mentee.update_attributes!(experience_in_years: 1)
    mentor.update_attributes!(experience_in_years: 2)

    assert_nothing_raised do
      create(:relationship, mentor: mentor, mentee: mentee)
    end
  end

  test 'update ensures mentee cannot be paired with a mentor without at least 1 more year of experience' do
    mentee.update_attributes!(experience_in_years: 6)
    mentor.update_attributes!(experience_in_years: 5)

    exception = assert_raises ActiveRecord::RecordInvalid do
      create(:relationship, mentor: mentor, mentee: mentee)
    end

    validation_message = I18n.t("activerecord.errors.models.relationship.attributes.base.mentor_not_experienced_enough_for_mentee")
    assert_includes exception.message, validation_message
  end

  private

  attr_reader :mentor, :mentee, :relationship
end
