Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "exam_schedules", to: "exam_schedules#index"
  get "exam_schedules/:id", to: "exam_schedules#show"
end
