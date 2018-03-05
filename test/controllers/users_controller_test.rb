require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "inherits from Clearance::UsersController" do
    expected_ancestor = Clearance::UsersController

    assert_includes UsersController.ancestors, expected_ancestor
    %i(create new).each do |method|
      assert UsersController.public_method_defined?(method)
    end
  end

  test "#show asks for more information on their profile if they haven't already saved them" do
    user = create(:user, :new, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get user_url(user)

    assert_template 'users/_details_form'
  end

  test "#show renders their complete profile if they have already saved more information" do
    user = create(:user, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get user_url(user)

    assert_template 'users/_details'
  end

  test "#create ensures name param is used to create new User record" do
    user_params = {
      email: 'new_user@gmail.com',
      password: '1234',
      name: 'New User'
    }

    post users_url, params: { user: user_params }

    new_user = User.last

    assert_equal 'New User', new_user.name
  end
end
