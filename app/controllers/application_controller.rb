class ApplicationController < ActionController::Base
  helper_method :current_identity, :identity_signed_in?, :warden_message

  protected

  def current_identity
    warden.user(scope: :identity)
  end

  def identity_signed_in?
    warden.authenticate?(scope: :identity)
  end

  def authenticate!
    redirect_to root_path, notice: t(".not_logged") unless identity_signed_in?
  end

  def warden_message
    warden.message
  end

  def warden
    request.env["warden"]
  end
end
