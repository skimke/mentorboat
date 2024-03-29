class UsersController < Clearance::UsersController
  def index
    page = params[:page]

    if current_user.is_admin?
      @users = User.where(is_approved: true).page(page)
    else
      redirect_to cohorts_url
    end
  end

  def show
    @user = User.find(params[:id])
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

  def edit
    @user = User.find(params[:id])
    redirect_to user_url(@user) unless current_user == @user
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_update_params)
      redirect_to user_url
    else
      render template: "users/edit"
    end
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
      :first_name,
      :last_name,
      :email,
      :position,
      :company,
      :experience_in_years
    )
  end
end
