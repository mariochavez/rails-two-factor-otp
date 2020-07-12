# frozen_string_literal: true

module Otp
  class ConfigureController < ApplicationController
    include Base
    before_action :authenticate!, :otp_not_enabled!

    def new
      @otp_secret = generate_otp_secret
      @qr_code = generate_qr_code_url(@otp_secret, current_identity.email)
    end

    def create
      otp_secret = params[:otp_secret]
      otp_code = params[:otp_code]

      last_otp_at = verify_otp_code(otp_secret, otp_code, nil)

      if last_otp_at.present?
        @recovery_codes = generate_recovery_codes
        current_identity.tap do |identity|
          identity.last_otp_at = Time.at(last_otp_at).utc.to_datetime
          identity.otp_secret_key = otp_secret
          identity.recovery_codes = @recovery_codes.join(" ")
          identity.save
        end

        redirect_to otp_complete_path, notice: "2AF enabled succesfully"
      else
        render json: {error: "Verification code is invalid"}, status: :unprocessable_entity
      end
    end
  end
end
