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

  private

  def ensure_admin
    unless current_user.is_admin?
      redirect_to user_url(current_user)
    end
  end
end
