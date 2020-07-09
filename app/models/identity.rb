class Identity < ActiveRecord::Base
  has_secure_password validations: true

  attr_encrypted :otp_secret_key, :recovery_codes, key: Base64.decode64(Rails.application.credentials.encryption[:otp_secret_key])

  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, if: ->(r) { r.password.present? }
end
