Rails.application.routes.draw do

  # course offerings routes
  get '/search', to: "course_offerings#search"
  resources :course_offerings do
    get '/registration_groups', to: "registration_groups#index"
  end

  resources :registration_requests do
    get 'show_with_params', on: :member
  end
  get '/course_offering_requests/:course_offering_id', to: "registration_requests#course_offering_requests"
  # resources :registration_request_items

  #login routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :terms
  post 'set_term', to: 'terms#set_term', as: :set_term
  post 'set_term_reg_requests', to: 'terms#set_term_reg_requests', as: :set_term_reg_requests
  get 'terms_dropdown', to: 'terms#terms_dropdown', as: :terms_dropdown

  # Defines the root path route ("/")
  root "course_offerings#index"
end
