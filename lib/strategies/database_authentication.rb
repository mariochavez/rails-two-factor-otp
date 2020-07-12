module Strategies
  class DatabaseAuthentication < ::Warden::Strategies::Base
    def valid?
      params["identity"].present?
    end

    def authenticate!
      identity = Identity.find_by(email: params.dig("identity", "email"))
        .try(:authenticate, params.dig("identity", "password"))

      return success! identity if identity
      fail! I18n.t("sessions.create.invalid_credentials")
    end
  end
end

Warden::Strategies.add(:database_authentication, Strategies::DatabaseAuthentication)
