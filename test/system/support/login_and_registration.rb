# frozen_string_literal: true

module LoginAndRegistration
  def login_user
    password = "ctiYxr3EPmMD"
    identity = identities(:user)

    visit "/log_in"
    assert_selector "h2", text: "New session"

    fill_in "Email", with: identity.email
    fill_in "Password", with: password

    click_on "Log in"
  end

  def register_user
    login_user

    click_on "Enable 2FA"
    click_on "Set up 2FA", wait: 5
    click_on "I've got an app", wait: 5

    code_node = page.find("p.has-text-centered.mt-3")
    code_text = code_node.text.scan(/(\w{4}\ ?)/)
    otp_secret = code_text[-8..-1].flatten.map(&:strip).join

    totp = ROTP::TOTP.new(otp_secret, issuer: Otp::Base::OTP_ISSUER)
    verification_code = totp.now

    fill_in "otp_code", with: verification_code
    click_on "Verify code"
    click_on "Saved my codes"

    verification_code
  end
end
