class AddOtpFieldsToIdentity < ActiveRecord::Migration[6.0]
  def change
    add_column(:identities, :encrypted_otp_secret_key, :string)
    add_column(:identities, :encrypted_otp_secret_key_iv, :string)
    add_column(:identities, :encrypted_recovery_codes, :string)
    add_column(:identities, :encrypted_recovery_codes_iv, :string)
    add_column(:identities, :last_otp_at, :timestamp)
    add_column(:identities, :otp_enabled_at, :timestamp)

    add_index(:identities, :encrypted_otp_secret_key_iv, unique: true)
    add_index(:identities, :encrypted_recovery_codes_iv, unique: true)
  end
end
