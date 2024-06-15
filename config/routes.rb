Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api#index"
  
  get "search_users", to: "api#search"
  post "create_user", to: "api#create", as: :create_user
  patch "api_edit/:id", to: "api#update", as: :api_edit
  get "popup/:id", to: "api#popup", as: :popup
  resources :api 
end
