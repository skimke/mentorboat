class CohortsController < ApplicationController
  def index
    page = params[:page]

    @cohorts = Cohort.page(page).without_count
  end
end
