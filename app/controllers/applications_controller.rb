class ApplicationsController < ApplicationController
  before_action :ensure_admin

  def preview_applications
    @mentors_pending_approval = User.mentors.pending_approval.page(1).per(10)
    @mentees_pending_approval = User.mentees.pending_approval.page(1).per(10)
    @has_more_mentors = !@mentors_pending_approval.last_page?
    @has_more_mentees = !@mentees_pending_approval.last_page?
  end

  def applications
    type = params[:type]
    page = params[:page]
    @title = 'title'

    if type == 'mentors'
      @title = type
      @users = User.pending_approval.mentors.page(page).without_count
    elsif type == 'mentees'
      @title = type
      @users = User.pending_approval.mentees.page(page).without_count
    else
      @users = User.pending_approval.page(page).without_count
    end
  end

  def show
    user_id = params[:user_id]
    @user = User.find(user_id)
  end

  def approve
    user_id = params[:user_id]
    @user = User.find(user_id)
    @cohorts = Cohort.all
  end

  def update
    user_id = update_params[:user_id]
    cohort_id = update_params[:cohort][:cohort_id]
    @user = User.find(user_id)
    cohort = Cohort.find(cohort_id)
    
    relationship = Relationship.new
    relationship.cohort = cohort

    if @user.willing_to_mentor?
      relationship.mentor = @user
    else
      relationship.mentee = @user
    end

    ActiveRecord::Base.transaction do
      @user.update_attributes!(is_approved: true)
      relationship.save!
    end

    redirect_to applications_path
  end

  private

  def ensure_admin
    unless current_user.is_admin?
      redirect_to user_url(current_user)
    end
  end

  def update_params
    params.permit(:user_id, cohort: [:cohort_id])
  end
end
