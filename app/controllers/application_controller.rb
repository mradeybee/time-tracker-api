class ApplicationController < ActionController::API
  rescue_from CustomError do |error|
    render json: {error: error.message}, status: error.status
  end

  def access_token
    request.env['HTTP_X_ACCESS_TOKEN']
  end

  def current_user
    user = User.find_by(id: AuthService.decode_token(access_token)["user"])

    if user && !TokenBlacklist.find_by(token: access_token).present?
      response.headers["jwt"] = AuthService.generate_token({user: user.id})
      user
    else
      raise CustomError.new(422), 'Invalid auth token'
    end
  end
end
