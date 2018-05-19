require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "#pair is blocked for non-admin users" do
    user = create(:user)
    relationship = create(
      :relationship,
      mentee: user,
      cohort: create(:cohort)
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get relationship_pair_url(relationship, user.id)

    assert_redirected_to signed_in_root_url
  end

  test "#pair returns success for admin users" do
    user = create(:user, :admin)
    relationship = create(
      :relationship,
      mentee: user,
      cohort: create(:cohort)
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get relationship_pair_url(relationship, user.id)

    assert_response :success
  end

  test "#update is blocked for non-admin users" do
    user = create(:user)
    relationship = create(
      :relationship,
      mentee: user,
      cohort: create(:cohort)
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    patch relationship_url(relationship)

    assert_redirected_to signed_in_root_url
  end

  test "#update sets user ids for a relationship based on params" do
    mentee = create(:user, :mentee)
    cohort = create(:cohort)
    relationship = create(
      :relationship,
      mentee: mentee,
      cohort: cohort
    )
      
    admin = create(:user, :admin)
    post session_url, params: { session: { email: admin.email, password: admin.password } }

    mentor = create(:user, :mentor)
    params = {
      mentor: { mentor_id: mentor.id },
      mentee: { mentee_id: mentee.id }
    }
    assert_changes -> {
      Relationship.where(
        mentee: mentee,
        mentor: mentor,
        cohort: cohort
      ).count
    }, from: 0, to: 1 do
      patch relationship_url(relationship), params: params
    end

    assert_equal mentor, relationship.reload.mentor
    assert_equal mentee, relationship.mentee
  end

  test "#update sets user ids for a relationship then removes an already existing relationship with exact same mentor, mentee, cohort" do
    mentee = create(:user, :mentee)
    mentor = create(:user, :mentor)
    cohort = create(:cohort)

    existing_relationship = create(
      :relationship,
      mentee: mentee,
      mentor: mentor,
      cohort: cohort
    )
    relationship = create(
      :relationship,
      mentee: mentee,
      cohort: cohort
    )

    admin = create(:user, :admin)
    post session_url, params: { session: { email: admin.email, password: admin.password } }

    params = {
      mentor: { mentor_id: mentor.id },
      mentee: { mentee_id: mentee.id }
    }
    assert_no_changes -> {
      Relationship.where(
        mentee: mentee,
        mentor: mentor,
        cohort: cohort
      ).count
    } do
      patch relationship_url(relationship), params: params
    end

    assert_equal mentor, relationship.reload.mentor
    assert_equal mentee, relationship.mentee
    
    assert_raises ActiveRecord::RecordNotFound do
      existing_relationship.reload
    end
  end
end
