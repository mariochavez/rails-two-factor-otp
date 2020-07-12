# frozen_string_literal: true

module Otp
  module Base
    OTP_ISSUER = "OTP Security with Rails"

    def generate_otp_secret
      ROTP::Base32.random
    end

    def verify_otp_code(otp_secret, otp_code, last_otp_at)
      params = {drift_behind: 15}
      params[:after] = last_otp_at.to_i if last_otp_at.present?

      totp_instance(otp_secret).verify(otp_code, **params)
    end

    def generate_qr_code_url(otp_secret, email)
      RQRCode::QRCode.new(totp_instance(otp_secret).provisioning_uri(email))
        .as_png(resize_exactly_to: 200)
        .to_data_url
    end

    def verify_recovery_code(string_recovery_codes, code)
      recovery_codes = string_recovery_codes&.split(" ")
      verified_code = recovery_codes&.delete(code)

      [verified_code, recovery_codes]
    end

    protected

    def generate_recovery_codes
      10.times.map { SecureRandom.alphanumeric(12) }
    end

    def otp_not_enabled!
      redirect_to root_path, notice: "2AF already enabled" if current_identity.otp_enabled_at.present?
    end

    def otp_enabled!
      redirect_to root_path, notice: "2AF not enabled" unless current_identity.otp_enabled_at?
    end

    private

    def totp_instance(otp_secret)
      ROTP::TOTP.new(otp_secret, issuer: OTP_ISSUER)
    end
  end
end
