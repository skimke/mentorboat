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
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get users_url

    assert_redirected_to cohorts_url
  end

  test "#index is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get users_url

    assert_response :success
  end

  test "#edit is blocked if user is trying to edit someone else's profile" do
    user = create(:user)
    other_user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get edit_user_url(other_user)

    assert_redirected_to user_url(other_user)
  end

  test "#edit is viewable for user when trying to edit their own profile" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get edit_user_url(user)

    assert_response :success
  end

  test "#show asks for more information on their profile if they haven't already saved them" do
    user = create(:user, :new)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get user_url(user)

    assert_select 'form.profile-details-form'
  end

  test "#show renders their complete profile if they have already saved more information" do
    user = create(:user)

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
    user = create(:user, :new)

    post session_url, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }

    put user_path(user), params: {
      user: {
        first_name: 'Severus',
        last_name: 'Snape',
        email: 'snivelly@hogwarts.magic',
        position: 'Potions Master',
        company: 'Hogwarts',
        experience_in_years: 999
      }
    }

    assert_equal 'Severus', user.reload.first_name
    assert_equal 'Snape', user.last_name
    assert_equal 'snivelly@hogwarts.magic', user.email
    assert_equal 'Potions Master', user.position
    assert_equal 'Hogwarts', user.company
    assert_equal 999, user.experience_in_years

    assert_redirected_to user_url(user)
  end
end
