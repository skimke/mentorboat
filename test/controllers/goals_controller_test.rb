require 'test_helper'

class GoalsControllerTest < ActionDispatch::IntegrationTest
  test '#new returns success for the user in the relationship' do
    user = create(:user, :mentee)
    relationship = create(
      :relationship,
      mentor: create(:user, :mentor),
      mentee: user,
      cohort: create(:cohort, :fall)
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get new_relationship_goal_url(relationship_id: relationship.id)

    assert_response :success
  end

  test '#new redirects to cohorts index for non-admin users' do
    user = create(:user)
    relationship = create(
      :relationship,
      mentor: create(:user, :mentor),
      mentee: create(:user, :mentee),
      cohort: create(:cohort, :fall)
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get new_relationship_goal_url(relationship_id: relationship.id)

    assert_redirected_to relationship_url(relationship)
  end
end
