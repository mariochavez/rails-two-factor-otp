# frozen_string_literal: true

module Otp
  class ConfigureController < ApplicationController
    before_action :authenticate!, :otp_not_enabled!

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
        @recovery_codes = generate_recovery_codes
        current_identity.tap do |identity|
          identity.last_otp_at = last_otp_at
          identity.otp_secret_key = otp_secret
          identity.recovery_codes = @recovery_codes.join(" ")
          identity.save
        end

        redirect_to otp_complete_path, notice: "2AF enabled succesfully"
      else
        render json: {error: "Verification code is invalid"}, status: :unprocessable_entity
      end
    end

    private

    def generate_recovery_codes
      10.times.map { SecureRandom.alphanumeric(12) }
    end

    def otp_not_enabled!
      redirect_to root_path, notice: "2AF already enabled" if current_identity.otp_enabled_at.present?
    end
  end
end
