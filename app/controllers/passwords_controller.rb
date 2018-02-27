class PasswordsController < Clearance::PasswordsController

  private

  def url_after_create
    log_in_url
  end
end
