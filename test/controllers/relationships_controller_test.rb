require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "#update is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    patch relationships_url

    assert_redirected_to signed_in_root_url
  end
end
