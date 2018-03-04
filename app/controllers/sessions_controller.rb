class SessionsController < Clearance::SessionsController

  private

  def url_after_destroy
    login_url
  end
end
