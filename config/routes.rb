Rails.application.routes.draw do

  scope "(:locale)", locale: /ru|en/ do
    scope '/home', module: 'home' do
      resources :user_sessions
      resources :oauths
    end
    scope '/dashboard', module: 'dashboard' do
      resources :homepage
      resources :cards
      resources :users
      resources :packs
    end
  end

  get 'oauths/oauth'
  get 'oauths/callback'
  post "oauth/callback" => "home/ohoauths#callback"
  get "oauth/callback" => "home/oauths#callback"
  get "oauth/:provider" => "home/oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "home/oauths#destroy", :as => :delete_oauth
  get 'login' => 'home/user_sessions#new', :as => :login
  post 'logout' => 'home/user_sessions#destroy', :as => :logout
  post '/packs/new', to: 'dashboard/packs#new', as: :new_pack_new
  post '/', to: 'dashboard/cards#check_card', as: :check_card, defaults: { format: 'js' }
  post '/users/:id', to: 'dashboard/users#set_default_pack', as: :set_pack
  root to: 'dashboard/homepage#index'
end
