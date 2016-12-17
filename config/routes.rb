Rails.application.routes.draw do

  get 'oauths/oauth'

  get 'oauths/callback'

  root to: 'homepage#index'

  resources :cards
  resources :users
  resources :user_sessions

  post '/', to: 'cards#check_card', as: :check_card
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth
end
