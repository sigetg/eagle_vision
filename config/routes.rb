Rails.application.routes.draw do
  resources :terms
  post 'set_term', to: 'terms#set_term', as: :set_term
  get 'terms_dropdown', to: 'terms#terms_dropdown', as: :terms_dropdown
  resources :people
  resources :course_offerings do
    resources :activity_offerings
    resources :registration_groups
  end
  resources :registration_groups
  get '/search', to: "course_offerings#search"
  resources :activity_offerings
  resources :registration_requests
  post '/registration_requests/:id(.:format)', to: "registration_requests#create"
  resources :registration_request_items

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "course_offerings#index"
end
