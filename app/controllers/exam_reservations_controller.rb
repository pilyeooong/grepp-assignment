class ExamReservationsController < ApplicationController
  include Validator

  # 모든 예약 조회
  # 해당 동작은 어드민만 가능하다
  def index
    user_id = params[:user_id]
    page = params[:page]
    limit = params[:limit]

    valid_page = validate_page_param(page)
    valid_limit = validate_limit_param(limit)

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    raise Errors::Forbidden.new(Errors::FORBIDDEN_MESSAGE) unless user.is_admin?

    exam_reservations = ExamReservation
                          .all
                          .order(created_at: :desc)
                          .offset((valid_page - 1) * valid_limit)
                          .limit(valid_limit)

    render_json(data: exam_reservations)
  end

  # 본인의 모든 예약 조회
  def my_reservations
    user_id = params[:user_id]
    page = params[:page]
    limit = params[:limit]
    is_confirmed = params[:is_confirmed]

    valid_page = validate_page_param(page)
    valid_limit = validate_limit_param(limit)

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    where_conditions = {}
    where_conditions[:user_id] = user.id
    where_conditions[:is_confirmed] = true if is_confirmed == 'true'
    where_conditions[:is_confirmed] = false if is_confirmed == 'false'

    exam_reservations = ExamReservation
                          .where(where_conditions)
                          .order(created_at: :desc)
                          .offset((valid_page - 1) * valid_limit)
                          .limit(valid_limit)

    render_json(data: exam_reservations)
  end

  # 예약 상세 조회
  # 해당 동작은 본인 혹은 어드민만 가능하다
  def show
    user_id = params[:user_id]
    exam_reservation_id = params[:exam_reservation_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    exam_reservation = ExamReservation.find_by(id: exam_reservation_id)
    raise Errors::NotExist.new(Errors::EXAM_RESERVATION_NOT_EXIST_MESSAGE) if exam_reservation.nil?

    raise Errors::Forbidden.new(Errors::FORBIDDEN_MESSAGE) if exam_reservation.user_id != user.id && !user.is_admin?

    render_json(data: exam_reservation)
  end

  # 예약 신청
  def create
    exam_schedule_id = params[:exam_schedule_id]
    user_id = params[:user_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    exam_schedule = ExamSchedule.find_by(id: exam_schedule_id)
    raise Errors::NotExist.new(Errors::EXAM_SCHEDULE_NOT_EXIST_MESSAGE) if exam_schedule.nil?

    # 시험 예약 조건 검증
    raise Errors::InvalidRequest.new(Errors::EXAM_RESERVATION_DATE_UNAVAILABLE_MESSAGE) unless exam_schedule.is_date_available?
    raise Errors::InvalidRequest.new(Errors::EXAM_RESERVATION_SLOTS_FULL_MESSAGE) unless exam_schedule.is_slots_available?

    exam_reservation = ExamReservation.find_by(user_id: user_id, exam_schedule_id: exam_schedule_id)
    raise Errors::InvalidRequest.new(Errors::ALREADY_RESERVED_EXAM_SCHEDULE_MESSAGE) if exam_reservation.present?

    new_exam_reservation = ExamReservation.create!(user_id: user_id, exam_schedule_id: exam_schedule_id, is_confirmed: false)

    render_json(data: new_exam_reservation)
  end

  # 예약 수정
  # 본인 혹은 어드민만 수정 가능하다.
  def update
    user_id = params[:user_id]
    exam_reservation_id = params[:exam_reservation_id]
    exam_schedule_id = params[:exam_schedule_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    exam_reservation = ExamReservation.find_by(id: exam_reservation_id)
    raise Errors::NotExist.new(Errors::EXAM_RESERVATION_NOT_EXIST_MESSAGE) if exam_reservation.nil?

    # 예약 수정 권한 체크
    raise Errors::Forbidden.new(Errors::FORBIDDEN_MESSAGE) if exam_reservation.user_id != user.id && !user.is_admin?

    # 예약 확정이 되었으면서, 관리자가 아닌 경우 예약 수정 시도 시 예외 발생
    raise Errors::InvalidRequest.new(Errors::CONFIRMED_RESERVATION_UPDATE_UNAVAILABLE_MESSAGE) if !user.is_admin? && exam_reservation.is_confirmed

    exam_schedule = ExamSchedule.find_by(id: exam_schedule_id)
    raise Errors::NotExist.new(Errors::EXAM_SCHEDULE_NOT_EXIST_MESSAGE) if exam_schedule.nil?

    raise Errors::InvalidRequest.new(Errors::EXAM_RESERVATION_DATE_UNAVAILABLE_MESSAGE) unless exam_schedule.is_date_available?
    raise Errors::InvalidRequest.new(Errors::EXAM_RESERVATION_SLOTS_FULL_MESSAGE) unless exam_schedule.is_slots_available?

    exists_exam_reservation = ExamReservation.find_by(user_id: user.id, exam_schedule_id: exam_schedule.id)
    raise Errors::NotExist.new(Errors::ALREADY_RESERVED_EXAM_SCHEDULE_MESSAGE) if exists_exam_reservation.present?

    exam_reservation.update!(exam_schedule_id: exam_schedule.id)

    render_json(data: exam_reservation)
  end

  # 예약 취소
  # 예약 확정 이전에만 취소가 가능하도록 한다. 확정 이후에는 삭제가 불가능하게끔 한다
  def destroy
    user_id = params[:user_id]
    exam_reservation_id = params[:exam_reservation_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    exam_reservation = ExamReservation.find_by(id: exam_reservation_id)
    raise Errors::NotExist.new(Errors::EXAM_RESERVATION_NOT_EXIST_MESSAGE) if exam_reservation.nil?

    raise Errors::Forbidden.new(Errors::FORBIDDEN_MESSAGE) if exam_reservation.user_id != user.id && !user.is_admin?

    raise Errors::InvalidRequest.new(Errors::CONFIRMED_RESERVATION_DESTROY_UNAVAILABLE_MESSAGE) if !user.is_admin? && exam_reservation.is_confirmed

    exam_reservation.destroy!

    render_json(data: exam_reservation)
  end

  # 예약 확정
  # 해당 동작은 어드민만 가능하다.
  def confirm_reservation
    user_id = params[:user_id]
    exam_reservation_id = params[:exam_reservation_id]

    user = User.find_by(id: user_id)
    raise Errors::NotExist.new(Errors::USER_NOT_EXIST_MESSAGE) if user.nil?

    exam_reservation = ExamReservation.find_by(id: exam_reservation_id)
    raise Errors::NotExist.new(Errors::EXAM_RESERVATION_NOT_EXIST_MESSAGE) if exam_reservation.nil?

    raise Errors::Forbidden.new(Errors::FORBIDDEN_MESSAGE) if !user.is_admin?

    exam_reservation.update!(is_confirmed: true, confirmed_at: Time.zone.now) if !exam_reservation.is_confirmed

    render_json(data: exam_reservation)
  end
end
