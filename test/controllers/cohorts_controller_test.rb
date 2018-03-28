require 'test_helper'

class CohortsControllerTest < ActionDispatch::IntegrationTest
  test '#index returns success with any user' do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_response :success

    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_response :success
  end

  test '#index shows a link to creating new cohorts for admin users' do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.other-links' do
      assert_select 'a', 2
    end
  end

  test '#index does not show a link to creating new cohorts for non-admin users' do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.other-links' do
      assert_select 'a', 1
    end
  end
end
