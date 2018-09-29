class ApplicationController < ActionController::API
  def access_token
    request.headers["HTTP_AUTHORIZATION"]
  end

  def current_user
    @current_user ||= User.find_by(id: TokenGenerator.decode_token(access_token)["user"])

    @current_user unless TokenBlacklist.find_by(token: access_token).present?
  end
end
