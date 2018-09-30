class ApplicationController < ActionController::API

  def render_unauthorized
    render json: {errors: 'Invalid Access Token'}, status: :unprocessable_entity
  end

  def render_ok(payload)
    render json: payload, status: :ok
  end

  def render_created(payload)
    render json: payload, status: :created
  end

  def render_errors(errors)
    render json: errors, status: :unprocessable_entity
  end

  def access_token
    request.headers["HTTP_AUTHORIZATION"]
  end

  def blacklist_access_token
    TokenBlacklist.create(token: access_token)
  end

  def generate_access_token(user_id)
    TokenGenerator.generate_token({user: user_id})
  end

  def current_user
    current_user ||= User.find_by(id: TokenGenerator.decode_token(access_token)["user"])

    current_user unless TokenBlacklist.find_by(token: access_token).present?
  end
end
