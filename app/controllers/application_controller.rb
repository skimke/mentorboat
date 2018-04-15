class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  private

  def ensure_admin
    redirect_to signed_in_root_url unless current_user.is_admin?
  end
end
