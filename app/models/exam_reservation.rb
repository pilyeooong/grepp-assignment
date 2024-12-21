class ExamReservation < ApplicationRecord
  belongs_to :user
  belongs_to :exam_schedule
end
