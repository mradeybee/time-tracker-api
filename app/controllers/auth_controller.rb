class AuthController < ApplicationController
  before_action :get_user_from_refresh_token, only: [:refresh_token, :logout]

  def refresh_token
    if @user && blacklist_access_token && @user.regenerate_refresh_token && @user.reload
      render_ok({jwt: generate_access_token(@user.id), refresh_token: @user.refresh_token})
    else
      render_unauthorized
    end
  end

  def login
    user = User.find_by_email(auth_params[:email])

    if user && user.authenticate(auth_params[:password])
      render_ok({jwt: generate_access_token(user.id), refresh_token: user.refresh_token})
    else
      User.new(password: 'N0Password', email: 'noemail@email.xom').authenticate(auth_params[:password]) # This prevents time attacks from detecting valid emails.
      render_errors({errors: 'Invalid Cridentials'})
    end
  end

  def logout
    if @user && blacklist_access_token && @user.regenerate_refresh_token
      render json: {}, status: :no_content
    else
      render_unauthorized
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