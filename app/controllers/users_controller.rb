class UsersController < Clearance::UsersController
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

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    user_name = user_params.delete(:name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.name = user_name
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
end
