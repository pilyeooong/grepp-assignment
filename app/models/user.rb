class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  has_many :exam_reservations

  ADMIN_USER_LEVEL = 100

  def is_admin?
    self.user_level >= 100
  end
end
