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
    page = params[:page]

    @cohort = Cohort.find(@cohort_id)
    @relationships = @cohort.relationships.page(page).per(10)
  end

  private

  def cohort_id
    @cohort_id = params[:id]
  end

  def ensure_admin_or_belongs_to_cohort
    cohort_id

    unless current_user.is_admin? || current_user_belongs_to_cohort?
      redirect_to cohorts_url
    end
  end

  def current_user_belongs_to_cohort?
    Cohort.by_id_and_user_id(@cohort_id, current_user.id).any?
  end
end
