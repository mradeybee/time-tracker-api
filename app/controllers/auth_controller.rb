class AuthController < ApplicationController
  before_action :get_user_from_refresh_token, only: [:refresh_token, :logout]

  def refresh_token
    if @user
      render json: {jwt: TokenGenerator.generate_token({user: @user.id})}, status: :ok
    else
      render json: {errors: 'Invalid Access Token'}, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by_email(auth_params[:email])
    if user && user.authenticate(auth_params[:password])
      render json: {jwt: TokenGenerator.generate_token({user: user.id}), refresh_token: user.refresh_token}, status: :ok
    else
      User.new(password: 'N0Password', email: 'noemail@email.xom').authenticate(auth_params[:password]) # This prevents time attacks from detecting valid emails.
      render json: {errors: 'Invalid Cridentials'}, status: :unprocessable_entity
    end
  end

  def logout
    TokenBlacklist.create(token: access_token)
    if @user && @user.regenerate_refresh_token
      render json: {}, status: :no_content
    else
      render json: {errors: 'Invalid Access Token'}, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:refresh_token, :email, :password)
  end

  def get_user_from_refresh_token
    @user = User.find_by_refresh_token(auth_params[:refresh_token])
  end
end