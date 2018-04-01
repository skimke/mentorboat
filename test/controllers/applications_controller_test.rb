require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "#applications_preview is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_preview_url

    assert_redirected_to signed_in_root_url
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

    assert_redirected_to signed_in_root_url
  end

  test "#applications is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get applications_url

    assert_response :success
  end

  test "#show is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get application_url(user)

    assert_redirected_to signed_in_root_url
  end

  test "#show is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get application_url(user)

    assert_response :success
  end

  test "#approve is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get approve_application_url(user)

    assert_redirected_to signed_in_root_url
  end

  test "#approve is viewable for admin users" do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get approve_application_url(user)

    assert_response :success
  end

  test "#update is blocked for non-admin users" do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    patch application_url(user)

    assert_redirected_to signed_in_root_url
  end

  test "#update updates is_approved to true for the application's user" do
    user = create(:user, :admin)
    non_admin = create(:user)
    
    post session_url, params: { session: { email: user.email, password: user.password } }
    
    cohort = create(:cohort)
    cohort_params = { cohort: { cohort_id: cohort.id } }

    assert_changes -> { Relationship.count } do
      patch application_url(non_admin), params: cohort_params
    end

    assert_redirected_to applications_path

    assert non_admin.reload.is_approved
  end

  test "#update sets a new relationship for a cohort and assigns a mentor if they are willing_to_mentor" do
    user = create(:user, :admin)
    mentor = create(:user, :mentor)
    
    post session_url, params: { session: { email: user.email, password: user.password } }
    
    cohort = create(:cohort)
    cohort_params = { cohort: { cohort_id: cohort.id } }

    assert_changes -> { Relationship.count } do
      patch application_url(mentor), params: cohort_params
    end

    assert_redirected_to applications_path

    new_relationship = Relationship.last

    assert_equal cohort, new_relationship.cohort
    assert_equal mentor, new_relationship.mentor
    assert_nil new_relationship.mentee
  end

  test "#update sets a new relationship for a cohort and assigns a mentee if they are not willing_to_mentor" do
    user = create(:user, :admin)
    mentee = create(:user, :mentee)
    
    post session_url, params: { session: { email: user.email, password: user.password } }
    
    cohort = create(:cohort)
    cohort_params = { cohort: { cohort_id: cohort.id } }

    assert_changes -> { Relationship.count } do
      patch application_url(mentee), params: cohort_params
    end

    assert_redirected_to applications_path

    new_relationship = Relationship.last

    assert_equal cohort, new_relationship.cohort
    assert_nil new_relationship.mentor
    assert_equal mentee, new_relationship.mentee
  end
end
