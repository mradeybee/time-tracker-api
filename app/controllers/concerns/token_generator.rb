require "jwt"
class TokenGenerator
  def self.secret
    'b258b53c90f5114abb07'
  end

  def self.generate_token(user_info)
    user_info.merge!(exp: Time.zone.now.to_i + 10 * 60 )
    JWT.encode user_info, secret, "HS512"
  end

  def self.decode_token(token)
    token = JWT.decode token, secret, true, algorithm: "HS512"
    token.first
  rescue JWT::DecodeError
    {error: 'invalid token'}
  end
end