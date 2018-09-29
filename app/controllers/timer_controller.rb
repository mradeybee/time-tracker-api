class TimerController < ApplicationController
  def create
    timer = timer_data

    if current_user.nil?
      render json: {errors: 'Invalid Access Token'}, status: :unprocessable_entity
    elsif timer.save
      render json: {timers: current_user.timers.order(created_at: :desc)}, status: :created
    else
      render json: {errors: timer.errors.full_messages.join(', ')}, status: :unprocessable_entity
    end
  end

  def user_timers
    if current_user.present?
      render json: {timers: current_user.timers.order(created_at: :desc)}, status: :ok
    else
      render json: {errors: 'Invalid Access Token'}, status: :unprocessable_entity
    end
  end

  private

  def timer_data
    timer_details = timer_params.merge(user_id: current_user.try(:id))
    Timer.new(timer_details)
  end

  def timer_params
    params.require(:timer).permit(:seconds, :start_at, :stop_at)
  end
end
