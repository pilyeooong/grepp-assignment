class Reservation < ApplicationRecord
  has_many :user_reservations
end
