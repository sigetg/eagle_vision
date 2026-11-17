Rails.application.routes.draw do
  # course offerings routes
  get "/search", to: "course_offerings#search"
  resources :course_offerings do
    get "/registration_groups", to: "registration_groups#index"
  end

  resources :registration_requests do
    get "show_with_params", on: :member
  end
  get "/course_offering_requests/:course_offering_id", to: "registration_requests#course_offering_requests"
  # resources :registration_request_items

  # login routes
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # The term picker in the top bar.
  resource :term, only: :update

  # Each role lands on its own home page.
  root "home#show"
end
