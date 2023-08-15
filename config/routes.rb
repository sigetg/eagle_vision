Rails.application.routes.draw do
  resources :terms
  resources :people
  resources :course_offerings
  resources :activity_offerings
  resources :registration_requests do
    resources :registration_request_items
  end

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
