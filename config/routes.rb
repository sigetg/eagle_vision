Rails.application.routes.draw do

  # course offerings routes
  get '/search', to: "course_offerings#search"
  resources :course_offerings do
    get '/registration_groups', to: "registration_groups#index"
  end

  resources :registration_requests
  get '/course_offering_requests/:course_offering_id', to: "registration_requests#course_offering_requests" #this should be a slash not a dot
  # resources :registration_request_items

  #login routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :terms
  post 'set_term', to: 'terms#set_term', as: :set_term
  get 'terms_dropdown', to: 'terms#terms_dropdown', as: :terms_dropdown

  # Defines the root path route ("/")
  root "course_offerings#index"
end
