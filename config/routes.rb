Rails.application.routes.draw do
  resources :registration_request_items
  resources :registration_requests
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :waitlist_requests
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "waitlist_requests#index"
end
