# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_08_183626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "identities", force: :cascade do |t|
    t.string "email"
    t.string "password_hash"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_recovery_codes"
    t.string "encrypted_recovery_codes_iv"
    t.datetime "last_otp_at"
    t.datetime "otp_enabled_at"
    t.index ["encrypted_otp_secret_key_iv"], name: "index_identities_on_encrypted_otp_secret_key_iv", unique: true
    t.index ["encrypted_recovery_codes_iv"], name: "index_identities_on_encrypted_recovery_codes_iv", unique: true
  end

end
