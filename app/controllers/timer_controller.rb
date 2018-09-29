class TimerController < ApplicationController
  def create
    timer_details = timer_params.merge(user_id: current_user.id)
    timer = Timer.new(timer_details)

    if timer.save
      render json: {timers: current_user.timers.order(created_at: :desc)}, status: :created
    else
      render json: { errors: timer.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end
  
  def user_timers
    render json: {timers: current_user.timers.order(created_at: :desc)}, status: :created
  end

  private

  def timer_params
    params.require(:timer).permit(:seconds, :start_at, :stop_at)
  end
end
