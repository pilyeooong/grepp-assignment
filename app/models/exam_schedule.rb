class ExamSchedule < ApplicationRecord
  acts_as_paranoid

  has_many :exam_reservations
end
