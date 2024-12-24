Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # exam schedules
  get "exam_schedules", to: "exam_schedules#index"
  get "exam_schedules/:id", to: "exam_schedules#show"

  # exam reservations
  get "exam_reservations", to: "exam_reservations#index"
  post "exam_reservations", to: "exam_reservations#create"
  get "exam_reservations/my", to: "exam_reservations#my_reservations"
  get "exam_reservations/:exam_reservation_id", to: "exam_reservations#show"
  patch "exam_reservations/:exam_reservation_id", to: "exam_reservations#update"
  delete "exam_reservations/:exam_reservation_id", to: "exam_reservations#destroy"
  post "exam_reservations/:exam_reservation_id/confirm", to: "exam_reservations#confirm_reservation"
end
