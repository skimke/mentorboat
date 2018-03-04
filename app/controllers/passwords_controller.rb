class PasswordsController < Clearance::PasswordsController

  private

  def url_after_create
    login_url
  end
end
