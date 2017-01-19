Rails.application.routes.draw do

 scope '/home', module: 'home' do
    scope "(:locale)", locale: /ru|en/ do
      resources :homepage, as: :homepage
      resources :user_sessions
      resources :oauths
    end
  end

  scope '/dashboard', module: 'dashboard' do
    scope "(:locale)", locale: /ru|en/ do
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
  root to: 'home/homepage#index'
end
