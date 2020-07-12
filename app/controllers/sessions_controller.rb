class SessionsController < ApplicationController
  before_action :logged_in!, except: :destroy

  layout "identity"

  def new
    @identity = Identity.new
  end

  def create
    identity = warden.authenticate!(scope: :identity)
    return redirect_to otp_new_verify_path if identity.otp_enabled_at?

    redirect_to root_url, notice: t(".logged_in")
  end

  def destroy
    warden.logout(:identity)
    redirect_to root_path, notice: t(".logged_out")
  end

  private

  def logged_in!
    return redirect_to root_path if identity_signed_in?
  end
end
