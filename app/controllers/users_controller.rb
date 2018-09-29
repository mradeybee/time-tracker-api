class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      token = TokenGenerator.generate_token({user: user.id})
      render json: {jwt: token, refresh_token: user.refresh_token}, status: :created
    else
      render json: {errors: user.errors.full_messages.join(', ')}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password)
  end
end
