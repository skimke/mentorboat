class SessionsController < Clearance::SessionsController

  private

  def url_after_destroy
    log_in_url
  end
end
