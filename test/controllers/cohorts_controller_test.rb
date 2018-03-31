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

  test '#index displays all cohorts for admin users' do
    user = create(:user, :admin)
    create(:cohort, :spring)
    create(:cohort, :summer)
    create(:cohort, :fall)
    create(:cohort, :winter)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.cohorts-list' do
      assert_select 'p', 4
    end
  end

  test '#index displays only cohorts that a user belongs to through their relationships if user is not an admin' do
    user = create(:user, :mentor)
    cohort_for_user_as_mentee = create(:cohort, :spring)
    cohort_for_user_as_mentor = create(:cohort, :summer)
    create(:cohort, :fall)
    create(:cohort, :winter)

    create(
      :relationship,
      mentor: create(:user, :mentor),
      mentee: user,
      cohort: cohort_for_user_as_mentee
    )
    create(
      :relationship,
      mentor: user,
      mentee: create(:user, :mentee),
      cohort: cohort_for_user_as_mentor
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.cohorts-list' do
      assert_select 'p', 2
    end
  end

  test '#index shows a link to creating new cohorts for admin users' do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.other-links' do
      assert_select 'a', 1
    end
  end

  test '#index does not show a link to creating new cohorts for non-admin users' do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohorts_url

    assert_select 'div.other-links' do
      assert_select 'a', 0
    end
  end

  test '#show redirects to index if user is not an admin and does not belong to a relationship in the cohort' do
    user = create(:user)
    cohort = create(:cohort, :spring)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohort_url(cohort)

    assert_redirected_to cohorts_url
  end

  test '#show returns success for admin users' do
    user = create(:user, :admin)
    cohort = create(:cohort, :spring)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohort_url(cohort)

    assert_response :success
  end

  test '#show returns success for non-admin users and belongs to a relationship in the cohort' do
    user = create(:user)
    cohort = create(:cohort, :spring)
    create(
      :relationship,
      mentor: create(:user, :mentor),
      mentee: user,
      cohort: cohort
    )

    post session_url, params: { session: { email: user.email, password: user.password } }

    get cohort_url(cohort)

    assert_response :success
  end
end
