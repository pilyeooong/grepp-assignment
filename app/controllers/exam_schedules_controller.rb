class ExamSchedulesController < ApplicationController
  include Validator

  def index
    page = params[:page]
    limit = params[:limit]

    valid_page = validate_page_param(page)
    valid_limit = validate_limit_param(limit)

    exam_schedules = ExamSchedule
                       .all
                       .offset((valid_page - 1) * valid_limit)
                       .limit(valid_limit)

    exam_schedule_objs = Resource.exam_schedule_items(exam_schedules: exam_schedules)

    render_json(data: exam_schedule_objs)
  end

  def show
    id = params[:id]

    exam_schedule = ExamSchedule.find_by(id: id)
    raise Errors::NotExist.new(Errors::EXAM_SCHEDULE_NOT_EXIST_MESSAGE) if exam_schedule.nil?

    render_json(data: Resource.exam_schedule_item(exam_schedule: exam_schedule))
  end
end
