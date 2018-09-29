class Timer < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :seconds, :start_at, :stop_at
end
