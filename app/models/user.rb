class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  has_many :exam_reservations

  def is_admin?
    self.user_level >= 100
  end
end
