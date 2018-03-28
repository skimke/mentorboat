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

  private

  attr_reader :mentor, :mentee, :relationship
end
