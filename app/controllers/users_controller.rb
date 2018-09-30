class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render_created({jwt: generate_access_token(user.id), refresh_token: user.refresh_token})
    else
      render_errors({errors: user.errors.full_messages.join(', ')})
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password)
  end
end
