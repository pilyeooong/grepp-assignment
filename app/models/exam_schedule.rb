class ExamSchedule < ApplicationRecord
  acts_as_paranoid

  has_many :exam_reservations

  # 날짜, 시간 정보를 합쳐 하나의 datetime으로 추출한다.
  def combine_datetime
    return nil if self.date.nil? || self.start_time.nil?

    self.date.to_datetime + self.start_time.seconds_since_midnight.seconds
  end

  # 시험 일정이 최소 3일이상 남았는지 검증한다.
  def is_date_available?
    combined_datetime = combine_datetime

    combined_datetime.to_i - Time.zone.now.to_i >= (60 * 60 * 24 * 3)
  end

  def get_available_slots_count
    available_slots = self.total_slots_count - self.confirmed_slots_count || 0
    return 0 if available_slots.to_i == 0

    not_confirmed_slots = ExamReservation.where(exam_schedule_id: self.id, is_confirmed: false).count || 0

    available_slots - not_confirmed_slots
  end

  # 접수 가능 인원이 다 차지 않았는지 검증한다.
  def is_slots_available?
    available_slots_count = get_available_slots_count
    available_slots_count > 0
  end

  # 시험 일정, 응시 가능 인원 등 예약 신청에 필요한 모든 조건들을 종합적으로 검증한다.
  def is_reservation_available?
    is_date_available? && is_slots_available?
  end
end
