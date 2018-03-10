require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @mentor = create(:user, :mentor)
    @mentee = create(:user, :mentee)
    
    @relationship = create(
      :relationship,
      mentor_id: mentor.id,
      mentee_id: mentee.id,
    )
  end

  test '#mentored_relationships returns all relationships where user is the mentee, not mentor' do
    assert_includes mentee.mentored_relationships, relationship

    refute_includes mentor.mentored_relationships, relationship
  end

  test '#mentoring_relationships returns all relationships where user is the mentor, not mentee' do
    assert_includes mentor.mentoring_relationships, relationship

    refute_includes mentee.mentoring_relationships, relationship
  end

  private

  attr_reader :mentor, :mentee, :relationship
end
