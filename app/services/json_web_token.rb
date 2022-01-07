# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = Time.zone.now)
      payload[:exp] = expire_token(exp)
      JWT.encode payload, Rails.application.secrets.secret_key_base
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature
      raise UnauthorizedError, ({ access_token: I18n.t('token.expired') })
    end

    private

    def expire_token(exp = Time.zone.now)
      (exp + 60.minutes).to_i
    end
  end
end
