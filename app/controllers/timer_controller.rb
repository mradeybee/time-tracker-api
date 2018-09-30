class TimerController < ApplicationController
  def create
    timer = timer_data

    if current_user.nil?
     render_unauthorized
    elsif timer.save
      render_created({timers: current_user.timers.order(created_at: :desc)})
    else
      render_errors({errors: timer.errors.full_messages.join(', ')})
    end
  end

  def user_timers
    if current_user.present?
      render_ok({timers: current_user.timers.order(created_at: :desc)})
    else
     render_unauthorized
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
