class ExamReservation < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :exam_schedule
end
