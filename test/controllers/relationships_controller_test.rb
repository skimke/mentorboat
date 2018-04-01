require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "#show is blocked for non-admin users" do
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

  test "#show returns success for admin users" do
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
end
