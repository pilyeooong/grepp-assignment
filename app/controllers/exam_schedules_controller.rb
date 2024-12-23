class ExamSchedulesController < ApplicationController
  include Validator

  def index
    page = params[:page]
    limit = params[:limit]

    valid_page = validate_page_param(page)
    valid_limit = validate_limit_param(limit)

    exam_scehdules = ExamSchedule
                       .all
                       .offset((valid_page - 1) * valid_limit)
                       .limit(valid_limit)

    exam_schedule_objs = exam_scehdules.map do |exam_schedule|
      json_exam_schedule = exam_schedule.as_json
      json_exam_schedule["available_slots_count"] = exam_schedule.get_available_slots_count

      json_exam_schedule
    end

    render_json(data: exam_schedule_objs)
  end

  def show
    id = params[:id]

    exam_schedule = ExamSchedule.find_by(id: id)
    raise Errors::NotExist.new(Errors::EXAM_SCHEDULE_NOT_EXIST_MESSAGE) if exam_schedule.nil?

    render_json(data: exam_schedule)
  end
end
