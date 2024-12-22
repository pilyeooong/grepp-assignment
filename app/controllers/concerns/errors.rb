module Errors
  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = "Invalid Request"

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = "Forbidden"

  NOT_EXIST = 404
  NOT_EXISTS_MESSAGE = "Not Exists"

  EXAM_SCHEDULE_NOT_EXIST_MESSAGE = "시험 일정이 존재하지 않습니다."
  USER_NOT_EXIST_MESSAGE = "유저가 존재하지 않습니다."

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
