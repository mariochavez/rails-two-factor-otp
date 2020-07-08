# frozen_string_literal: true

module Otp
  class ConfigureController < ApplicationController
    before_action :authenticate!

    OTP_ISSUER = "OTP Security with Rails"

    def new
      @otp_secret = ROTP::Base32.random
      totp = ROTP::TOTP.new(@otp_secret, issuer: OTP_ISSUER)

      @qr_code = RQRCode::QRCode.new(totp.provisioning_uri(current_identity.email))
        .as_png(resize_exactly_to: 200)
        .to_data_url
    end

    def create
      otp_secret = params[:otp_secret]
      otp_code = params[:otp_code]

      totp = ROTP::TOTP.new(otp_secret, issuer: OTP_ISSUER)
      last_otp_at = totp.verify(otp_code, drift_behind: 15)

      if last_otp_at.present?
      else
        render json: {error: "Verification code is invalid"}, status: :unprocessable_entity
      end
    end
  end
end
