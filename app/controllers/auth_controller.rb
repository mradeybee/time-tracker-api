class AuthController < ApplicationController
  before_action :get_user_from_refresh_token, only: [:refresh_token, :logout]
  def refresh_token
    if @user
      render json: {jwt: TokenGenerator.generate_token({user: @user.id})}, status: :ok
    else
      render json: {error: 'Invalid auth token'}
    end
  end

  def login
    user = User.find_by_email(auth_params[:email])
    if user && user.authenticate(auth_params[:password])
      render json: {jwt: TokenGenerator.generate_token({user: user.id}), refresh_token: user.refresh_token}, status: :created
    else
      User.new(name: 'None', password: 'N0Password', email: 'noemail@email.xom').authenticate(auth_params[:password])
      render json: {error: 'Invalid cridentials'}
    end
  end

  def logout
    if @user && @user.regenerate_refresh_token
      TokenBlacklist.create(token: access_token)
      render json: {}, status: :no_content
    else
      render json: {error: 'Invalid token'}
    end
  end

  private

  def auth_params
    params.permit(:refresh_token, :email, :password)
  end

  def get_user_from_refresh_token
    @user = User.find_by_refresh_token(auth_params[:refresh_token])
  end
end