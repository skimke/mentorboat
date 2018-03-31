class CohortsController < ApplicationController
  before_action :ensure_admin_or_belongs_to_cohort, only: :show

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

  def show
  end

  private

  def ensure_admin_or_belongs_to_cohort
    unless current_user.is_admin? || current_user_belongs_to_cohort?(params[:id])
      redirect_to cohorts_url
    end
  end

  def current_user_belongs_to_cohort?(cohort_id)
    Cohort.by_id_and_user_id(cohort_id, current_user.id).any?
  end
end
