Rails.application.routes.draw do
  # Find courses and the course page, for both roles.
  resources :courses, only: %i[ index show ] do
    resources :requests, only: %i[ new create ]
  end

  # login routes
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # My requests: a student's own requests, with Edit and Withdraw.
  resources :requests, only: %i[ index edit update destroy ]

  namespace :staff do
    resources :requests, only: %i[ index show ] do
      resource :decision, only: :create
    end
    get "courses/:course_offering_id/requests", to: redirect { |params, _| "/courses/#{params[:course_offering_id]}#requests" },
                                                 as: :course_requests
  end

  # The term picker in the top bar.
  resource :term, only: :update

  # Each role lands on its own home page.
  root "home#show"
end
