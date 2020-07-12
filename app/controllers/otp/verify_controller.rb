# frozen_string_literal: true

module Otp
  class VerifyController < ApplicationController
    include Base
    before_action :authenticate!, :otp_enabled!

    layout "identity"

    def new
    end

    def create
      code = params[:code]&.strip
      verified = false

      if present_code?(code)
        last_otp_at = verify_otp_code(current_identity.otp_secret_key, code, current_identity.last_otp_at)

        if last_otp_at.present?
          current_identity.update(last_otp_at: Time.at(last_otp_at).utc.to_datetime)
          verified = true

        else
          verified_code, recovery_codes = verify_recovery_code(current_identity.recovery_codes, code)
          if verified_code.present?
            current_identity.update(recovery_codes: recovery_codes.join(" "))
            verified = true
          end
        end

        if verified
          warden.session(:identity)["otp_verified"] = true
          return redirect_to root_path, notice: t(".logged_in")
        end
      end

      render json: {error: "Verification code is invalid"}, status: :unprocessable_entity
    end

    private

    def present_code?(code)
      !(code.blank? || code.size < 6)
    end

    def authenticate!
      warden.authenticate?(scope: :identity)
    end
  end
end
