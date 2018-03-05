require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "inherits from Clearance::UsersController" do
    expected_ancestor = Clearance::UsersController

    assert_includes UsersController.ancestors, expected_ancestor
    %i(create new).each do |method|
      assert UsersController.public_method_defined?(method)
    end
  end

  test "#index is blocked for non-admin users" do
    user = create(:user, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_url

    assert_redirected_to user_url(user)
  end

  test "#index is viewable for admin users" do
    user = create(:user, :admin, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_url

    assert_response :success
  end

  test "#show asks for more information on their profile if they haven't already saved them" do
    user = create(:user, :new, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get user_url(user)

    assert_select 'form.profile-details-form'
  end

  test "#show renders their complete profile if they have already saved more information" do
    user = create(:user, password: 1234)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get user_url(user)

    assert_select 'div.profile-details'
  end

  test "#create ensures name param is used to create new User record" do
    user_params = {
      email: 'new_user@gmail.com',
      password: '1234',
      first_name: 'New',
      last_name: 'User'
    }

    post users_url, params: { user: user_params }

    new_user = User.last

    assert_equal 'New', new_user.first_name
    assert_equal 'User', new_user.last_name
  end

  test "#update stores all params to existing user" do
    user = create(:user, :new, password: 1111)

    post session_url, params: { session: { email: user.email, password: user.password } }

    put user_path(user), params: { user: { position: 'Magician', company: 'Hogwarts' } }

    assert_equal 'Magician', user.reload.position
    assert_equal 'Hogwarts', user.company

    assert_redirected_to user_url(user)
  end
end
