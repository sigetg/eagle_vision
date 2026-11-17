Rails.application.routes.draw do
  # Find courses and the course page, for both roles.
  resources :courses, only: %i[ index show ] do
    resources :requests, only: %i[ new create ]
  end

  resources :registration_requests do
    get "show_with_params", on: :member
  end
  # resources :registration_request_items

  # login routes
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # My requests (rebuilt in PR 10).
  get "requests", to: "registration_requests#index", as: :requests

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
