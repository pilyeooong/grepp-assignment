class ExamSchedulesController < ApplicationController
  def index
    exam_scehdules = ExamSchedule.all

    render_json(data: exam_scehdules, status: :ok)
  end

  def show
    id = params[:id]

    exam_schedule = ExamSchedule.find_by(id: id)
    raise Errors::NotExist.new(Errors::EXAM_SCHEDULE_NOT_EXIST_MESSAGE) if exam_schedule.nil?

    render_json(data: exam_schedule)
  end

  def create
  end

  def update
  end
end
