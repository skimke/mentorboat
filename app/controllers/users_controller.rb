class UsersController < Clearance::UsersController
  before_action :ensure_admin, only: [:applications, :index]

  def applications
    @mentors_pending_approval = User.mentors.pending_approval.page(1).per(10)
    @mentees_pending_approval = User.mentees.pending_approval.page(1).per(10)
    @has_more_mentors = !@mentors_pending_approval.last_page?
    @has_more_mentees = !@mentees_pending_approval.last_page?
  end

  def index
    type = params[:type]
    page = params[:page]
    @title = 'title'

    if type == 'mentors'
      @title = type
      @users = User.mentors.page(page).without_count
    elsif type == 'mentees'
      @title = type
      @users = User.mentees.page(page).without_count
    end
  end

  def show
    @user = current_user
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  def update
    @user = current_user

    @user.update_attributes!(user_update_params)
    redirect_to user_url
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    first_name = user_params.delete(:first_name)
    last_name = user_params.delete(:last_name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.first_name = first_name
      user.last_name = last_name
    end
  end

  def redirect_signed_in_users
    if signed_in?
      redirect_to user_url(@user)
    end
  end

  def user_update_params
    params.require(:user).permit(
      :position,
      :company,
      :experience_in_years
    )
  end

  def ensure_admin
    unless current_user.is_admin?
      redirect_to user_url(current_user)
    end
  end
end
