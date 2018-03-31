class CohortsController < ApplicationController
  before_action :ensure_admin, only: [:new, :create, :edit, :update]
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

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = cohort_from_params

    if @cohort.save
      redirect_to cohort_url(@cohort)
    end
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def update
    @cohort = Cohort.find(params[:id])

    @cohort.update_attributes!(cohort_params)
    redirect_to cohort_url(@cohort)
  end

  private

  def cohort_from_params
    Cohort.new(cohort_params)
  end

  def cohort_params
    params.require(:cohort).permit(
      :name,
      :starts_at,
      :ends_at
    )
  end

  def ensure_admin
    redirect_to cohorts_url unless current_user.is_admin?
  end

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
