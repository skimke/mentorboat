require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "inherits public methods from Clearance::SessionsController" do
    expected_ancestor = Clearance::SessionsController

    assert_includes SessionsController.ancestors, expected_ancestor
    %i(create destroy new).each do |method|
      assert SessionsController.public_method_defined?(method)
    end
  end

  test "#destroy redirects to login_url" do
    delete logout_url

    assert_redirected_to login_url
  end

  test "#create redirects to root" do
    user = create(:user, password: 1111)

    post session_url, params: { session: { email: user.email, password: user.password } }

    assert_redirected_to root_url
  end
end
