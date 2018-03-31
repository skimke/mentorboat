class CohortsController < ApplicationController
  def index
    page = params[:page]

    if current_user.is_admin?
      @cohorts = Cohort.page(page).without_count
    else
      cohorts_for_user = current_user.cohorts
      @cohorts = Kaminari.paginate_array(cohorts_for_user)
        .page(page).per(10)
    end
  end
end
