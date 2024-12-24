module Errors
  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = "Invalid Request"

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = "Forbidden"

  NOT_EXIST = 404
  NOT_EXISTS_MESSAGE = "Not Exists"

  EXAM_SCHEDULE_NOT_EXIST_MESSAGE = "시험 일정이 존재하지 않습니다."
  EXAM_RESERVATION_NOT_EXIST_MESSAGE = "예약이 존재하지 않습니다."
  USER_NOT_EXIST_MESSAGE = "유저가 존재하지 않습니다."
  INVALID_PASSWORD_MESSAGE = "비밀번호가 일치하지 않습니다."
  ALREADY_USED_EMAIL_MESSAGE = "이미 해당 이메일로 가입된 계정이 존재합니다."

  EXAM_RESERVATION_SLOTS_FULL_MESSAGE = "해당 일정에는 응시 가능 인원이 이미 최대치입니다."
  EXAM_RESERVATION_DATE_UNAVAILABLE_MESSAGE = "응시 신청 일정이 마감된 시험입니다."

  ALREADY_RESERVED_EXAM_SCHEDULE_MESSAGE = "이미 해당 일정에 예약 신청이 되어 있습니다."
  CONFIRMED_RESERVATION_UPDATE_UNAVAILABLE_MESSAGE = "확정된 예약은 수정이 불가능 합니다."
  CONFIRMED_RESERVATION_DESTROY_UNAVAILABLE_MESSAGE = "확정된 예약은 취소가 불가능 합니다."

  class Forbidden < StandardError
    def initialize(message = FORBIDDEN_MESSAGE)
      super(message)
    end

    def code
      FORBIDDEN
    end
  end

  class InvalidRequest < StandardError
    def initialize(message = INVALID_REQUEST_MESSAGE)
      super(message)
    end

    def code
      INVALID_REQUEST
    end
  end

  class NotExist < StandardError
    def initialize(message = NOT_EXISTS_MESSAGE)
      super(message)
    end

    def code
      NOT_EXIST
    end
  end
end
