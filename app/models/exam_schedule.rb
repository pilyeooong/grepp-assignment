class ExamSchedule < ApplicationRecord
  has_many :exam_reservations
end
