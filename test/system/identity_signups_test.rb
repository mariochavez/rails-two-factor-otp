require "application_system_test_case"

class IdentitySignupsTest < ApplicationSystemTestCase
  test "Visit sign up form, completes registration, log out, and log in back" do
    # Register new identity
    visit "/sign_up"
    assert_selector "h2", text: "Registration"

    email = "user@system.test"
    password = SecureRandom.base58(12)

    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password

    click_on "Create identity"
    assert_text "Welcome to your new account!"

    # Log out
    click_on "Log out"
    assert_text "See you later!"

    # Log in back
    click_on "Log in"
    assert_selector "h2", text: "New session"

    fill_in "Email", with: email
    fill_in "Password", with: password

    click_on "Log in"
    assert_text email
  end
end
