Rails.application.routes.draw do

  get 'oauths/oauth'

  get 'oauths/callback'

  root to: 'homepage#index'

  resources :cards
  resources :users
  resources :user_sessions
  resources :packs

  post '/', to: 'cards#check_card', as: :check_card
  post '/users/:id', to: 'users#set_default_pack', as: :set_pack
  post '/packs/new', to: 'packs#new', as: :new_pack_new
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth
end
