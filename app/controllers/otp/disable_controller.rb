# frozen_string_literal: true

module Otp
  class DisableController < ApplicationController
    before_action :authenticate!, :otp_enabled!

    def show
    end

    def destroy
      current_identity.tap do |identity|
        identity.last_otp_at = nil
        identity.otp_secret_key = nil
        identity.recovery_codes = nil
        identity.otp_enabled_at = nil
        identity.save
      end

      redirect_to root_path, notice: "2FA disabled succesfully"
    end

    private

    def otp_enabled!
      redirect_to root_path, notice: "2AF not enabled" unless current_identity.otp_enabled_at?
    end
  end
end
