class ApplicationController < ActionController::API
  rescue_from CustomError do |error|
    render json: {error: error.message}, status: :unprocessable_entity
  end

  def access_token
    request.headers["HTTP_AUTHORIZATION"]
  end

  def current_user
    user = User.find_by(id: TokenGenerator.decode_token(access_token)["user"])

    if user && !TokenBlacklist.find_by(token: access_token).present?
      response.headers["jwt"] = TokenGenerator.generate_token({user: user.id})
      user
    end
  end
end
