require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "inherits from Clearance::UsersController" do
    expected_ancestor = Clearance::UsersController

    assert_includes UsersController.ancestors, expected_ancestor
    %i(create new).each do |method|
      UsersController.public_method_defined?(method)
    end
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
