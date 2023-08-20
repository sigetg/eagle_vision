Rails.application.routes.draw do
  resources :terms
  resources :people
  resources :course_offerings do
    resources :activity_offerings
  end
  get '/search', to: "course_offerings#search"
  resources :activity_offerings
  resources :registration_requests
  resources :registration_request_items

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :waitlist_requests
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "course_offerings#index"
end
