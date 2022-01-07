# frozen_string_literal: true

module UserHelper
  def generate_access_token(user)
    payload = user.as_json
    JsonWebToken.encode(payload.merge(server_time: Time.zone.now))
  end
end
