# frozen_string_literal: true

require "application_system_test_case"
require_relative "./support/login_and_registration"

class IdentityDisable2faTest < ApplicationSystemTestCase
  include LoginAndRegistration
  test "Disable 2FA and log in back" do
    register_user
    login_user

    # Verify with new verification code
    identity = identities(:user).reload

    travel_to Time.now + 60.seconds do
      totp = ROTP::TOTP.new(identity.otp_secret_key, issuer: Otp::Base::OTP_ISSUER)
      verification_code = totp.now

      fill_in "code", with: verification_code
      click_on "Verify code"
    end

    # Diable 2FA
    click_on "Disable 2FA"
    click_on "Yes, disable 2FA", wait: 5

    # Login without verification
    click_on "Log out"
    login_user
    assert_text "Enable 2FA"
  end
end
