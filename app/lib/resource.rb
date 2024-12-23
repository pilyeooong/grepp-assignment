module Resource
  def self.exam_schedule_items(exam_schedules:)
    exam_schedules.map do |exam_schedule_item|
      exam_schedule_item(exam_schedule: exam_schedule_item)
    end
  end

  def self.exam_schedule_item(exam_schedule:)
    json_exam_schedule = exam_schedule.as_json
    json_exam_schedule["available_slots_count"] = exam_schedule.get_available_slots_count

    json_exam_schedule
  end
end
