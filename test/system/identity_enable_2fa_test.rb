# frozen_string_literal: true

require "application_system_test_case"
require_relative "./support/login_and_registration"

class IdentityEnable2faTest < ApplicationSystemTestCase
  include LoginAndRegistration

  test "Enable 2FA and log in back" do
    # Gets an identity from fixtures
    password = "ctiYxr3EPmMD"
    identity = identities(:user)

    # Visit log in and fill form
    visit "/log_in"
    assert_selector "h2", text: "New session"

    fill_in "Email", with: identity.email
    fill_in "Password", with: password

    click_on "Log in"

    # After login set up 2FA
    click_on "Enable 2FA"
    click_on "Set up 2FA", wait: 5
    click_on "I've got an app", wait: 5

    # Find OTP secret code to verify account
    code_node = page.find("p.has-text-centered.mt-3")
    code_text = code_node.text.scan(/(\w{4}\ ?)/)
    otp_secret = code_text[-8..-1].flatten.map(&:strip).join

    totp = ROTP::TOTP.new(otp_secret, issuer: Otp::Base::OTP_ISSUER)
    verification_code = totp.now

    fill_in "otp_code", with: verification_code
    click_on "Verify code"
    click_on "Saved my codes"

    # Visit log in and try the two-factor verification
    visit "/log_in"
    assert_selector "h2", text: "New session"

    fill_in "Email", with: identity.email
    fill_in "Password", with: password

    click_on "Log in"
    assert_selector "h2", text: "Verify"

    # Due to security a verification can't be reused so we need to travel to future to get a new code
    travel_to Time.now + 31.seconds do
      verification_code = totp.now
      fill_in "code", with: verification_code
      click_on "Verify code"

      assert_text "Disable 2FA"
    end
  end

  test "Log in with invalid code and then use a recovery code" do
    register_user
    login_user

    # Use invalid verification code
    assert_selector "h2", text: "Verify"
    fill_in "code", with: "INVALID"
    click_on "Verify code"
    assert_text "Verification code is invalid"

    # Use a recovery code to log in
    assert_selector "h2", text: "Verify"
    identity = identities(:user).reload
    recovery_code = identity.recovery_codes.split(" ").first

    fill_in "code", with: recovery_code
    click_on "Verify code"

    click_on "Log out"
    login_user

    # Try to login with used recovery code
    assert_selector "h2", text: "Verify"
    fill_in "code", with: recovery_code
    click_on "Verify code"
    assert_text "Verification code is invalid"
  end

  test "Prevent to reuse not expired verification code" do
    verification_code = register_user
    login_user

    # Can't reuse already used verification code
    assert_selector "h2", text: "Verify"
    fill_in "code", with: verification_code
    click_on "Verify code"
    assert_text "Verification code is invalid"
  end
end
