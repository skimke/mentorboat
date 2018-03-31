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

  test '#new returns success for admin users' do
    user = create(:user, :admin)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get new_cohort_url

    assert_response :success
  end

  test '#new redirects to cohorts index for non-admin users' do
    user = create(:user)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get new_cohort_url

    assert_redirected_to cohorts_url
  end

  test '#edit returns success for admin users' do
    user = create(:user, :admin)
    cohort = create(:cohort, :spring)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get edit_cohort_url(cohort)

    assert_response :success
  end

  test '#edit redirects to cohorts index for non-admin users' do
    user = create(:user)
    cohort = create(:cohort, :spring)

    post session_url, params: { session: { email: user.email, password: user.password } }

    get edit_cohort_url(cohort)

    assert_redirected_to cohorts_url
  end

  test '#create returns success for admin users' do
    user = create(:user, :admin)
    post session_url, params: { session: { email: user.email, password: user.password } }

    cohort_params = {
      name: 'New Cohort',
      starts_at: Date.new(2018, 3, 1),
      ends_at: Date.new(2018, 5, 1)
    }

    assert_changes -> { Cohort.count } do
      post cohorts_url, params: { cohort: cohort_params }
    end

    new_cohort = Cohort.last

    assert_equal 'New Cohort', new_cohort.name
    assert_equal Date.new(2018, 3, 1), new_cohort.starts_at
    assert_in_delta Date.new(2018, 5, 1).end_of_day, new_cohort.ends_at, 1.second

    assert_redirected_to cohort_url(new_cohort)
  end

  test '#create redirects to cohorts index for non-admin users' do
    user = create(:user)
    post session_url, params: { session: { email: user.email, password: user.password } }

    assert_no_changes -> { Cohort.count } do
      post cohorts_url
    end

    assert_redirected_to cohorts_url
  end

  test '#update returns success for admin users' do
    user = create(:user, :admin)
    cohort = create(:cohort, :spring, name: 'Spring')
    post session_url, params: { session: { email: user.email, password: user.password } }

    cohort_params = { name: 'Different Cohort Name' }

    assert_changes -> { cohort.reload.name }, from: 'Spring', to: 'Different Cohort Name' do
      put cohort_url(cohort), params: { cohort: cohort_params }
    end

    assert_redirected_to cohort_url(cohort)
  end

  test '#update redirects to cohorts index for non-admin users' do
    user = create(:user)
    cohort = create(:cohort, :spring)
    post session_url, params: { session: { email: user.email, password: user.password } }

    assert_no_changes -> { cohort.reload } do
      put cohort_url(cohort)
    end

    assert_redirected_to cohorts_url
  end
end
