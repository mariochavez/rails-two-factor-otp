# README

Rails sample application on how to implement a Two-Factor authentication with OTP.

This authentication system for this application uses Rails' [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password)
but OTP logic is separated as much of possible from authentication code, this opens the opportunity to make it work with other authentication systems.

To run the application, remove the file `config/credentials.yml.enc` and create a new one with `bin/rails credentials:edit` command.
All OTP related secrets are encrypted in the database using [attr_encrypt](https://github.com/attr-encrypted/attr_encrypted). The credentials file needs the attr_encrypt key.
You can generate a new one with `Base64.encode64(SecureRandom.random_bytes(32))`. Save the key in the credentials file.

```
encryption:
  otp_secret_key: MY-SECRET-KEY
```

With the key in place, bundle your dependencies and start the server.

## Two Factor OTP

Two-Factor OTP is implemented with [RTop ](https://github.com/mdp/rotp) gem. This library can generate and validate one
time passwords and is compatible with Google Authenticator and other compatible generators like [Authy](https://authy.com/).

## Implementation

Rails OTP implementation can be found inside `Otp` namespace.

### Registration
![Registration](/docs/login-without-otp.gif)

### Enable Two-Factor OTP
![Two-Factor](/docs/login-with-otp.gif)

### Login with Recovery code
![Recovery code](/docs/login-with-recovery-code.gif)

### Disable Two-Factor OTP
![Disable OTP](/docs/disable-otp.gif)

## Testing
This sample application includes System Test for different scenarios. Tests have comments to help understand what is going on.
To run tests execute `bin/rails test:system`.

Note: System Tests are configured to run with Chrome headless.
