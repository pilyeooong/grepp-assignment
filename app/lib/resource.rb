module Resource
  def self.exam_schedule_item(exam_schedule:)
    {
      id: exam_schedule.id,
      date: exam_schedule.date,
      start_time: exam_schedule.start_time,
      end_time: exam_schedule.end_time,
      total_slots_count: exam_schedule.total_slots_count,
      available_slots_count: exam_schedule.get_available_slots_count,
      created_at: exam_schedule.created_at,
      updated_at: exam_schedule.updated_at,
      deleted_at: exam_schedule.deleted_at,
    }
  end

  def self.exam_schedule_items(exam_schedules:)
    exam_schedules.map do |exam_schedule_item|
      exam_schedule_item(exam_schedule: exam_schedule_item)
    end
  end

  def self.exam_reservation_item(exam_reservation:)
    {
      id: exam_reservation.id,
      user_id: exam_reservation.user_id,
      exam_schedule_id: exam_reservation.exam_schedule_id,
      is_confirmed: exam_reservation.is_confirmed,
      confirmed_at: exam_reservation.confirmed_at,
      created_at: exam_reservation.created_at,
      updated_at: exam_reservation.updated_at,
      deleted_at: exam_reservation.deleted_at,
    }
  end

  def self.exam_reservation_items(exam_reservations:)
    exam_reservations.map do |exam_reservation|
      exam_reservation_item(exam_reservation: exam_reservation)
    end
  end
end
