# frozen_string_literal: true

module Otp
  class CompleteController < ApplicationController
    before_action :authenticate!, :otp_not_enabled!

    def show
      current_identity.update_column(:otp_enabled_at, Time.zone.now)
      @recovery_codes = current_identity.recovery_codes.split(" ")
    end

    private

    def otp_not_enabled!
      redirect_to root_path, notice: "2AF already enabled" if current_identity.otp_enabled_at?
    end
  end
end
