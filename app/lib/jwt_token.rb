module JwtToken
  HMAC_SECRET = ENV["JWT_TOKEN_SECRET"] || "jwt_token_secret"
  TOKEN_TYPE = "Bearer"
  TOKEN_EXPIRATION = 90 * 24 * 3600

  def self.generate_token(data)
    exp = Time.now.to_i + TOKEN_EXPIRATION
    iat = Time.now.to_i
    iss = "grepp"
    payload = { data: data, exp: exp, iat: iat, iss: iss }
    encode(payload)
  end

  def self.encode(payload)
    JWT.encode payload, HMAC_SECRET, "HS512"
  end

  def self.decode(token)
    JWT.decode token, HMAC_SECRET, true, { verify_iat: true, verify_iss: true, algorithm: "HS512" }
  end

  def self.get_user_id_from_token(decoded_token)
    decoded_token[0]["data"]["user_id"]
  end

  def self.check_decode(token)
    decoded_token = decode(token)
    user_id = get_user_id_from_token(decoded_token)
    raise Errors::InvalidRequest.new(Errors::INVALID_REQUEST_MESSAGE) if user_id.blank?

    user_id
  rescue Exception => e
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)

    nil
  end

  def self.verify(token)
    user_id = check_decode(token)
    return nil if user_id.nil?

    User.find_by(id: user_id)
  end
end
