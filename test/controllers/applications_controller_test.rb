require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "#applications_preview is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_preview_url

    assert_redirected_to user_url(user)
  end

  test "#applications_preview is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_preview_url

    assert_response :success
  end

  test "#applications is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_url

    assert_redirected_to user_url(user)
  end

  test "#applications is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_url

    assert_response :success
  end
end
