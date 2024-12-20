class Reservation < ApplicationRecord
  validate :start_time_before_end_time

  def start_time_before_end_time
  end
end
