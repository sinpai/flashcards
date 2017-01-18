Rails.application.routes.draw do

 scope '/home', module: 'home' do
    get 'oauths/oauth'
    get 'oauths/callback'
    post "oauth/callback" => "oauths#callback"
    get "oauth/callback" => "oauths#callback"
    get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
    delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth
    scope "(:locale)", locale: /ru|en/ do
      resources :homepage, as: :homepage
      resources :user_sessions
      get 'login' => 'user_sessions#new', :as => :login
      post 'logout' => 'user_sessions#destroy', :as => :logout
    end
  end

  scope '/dashboard', module: 'dashboard' do
    scope "(:locale)", locale: /ru|en/ do
      resources :cards
      resources :users
      resources :packs
      post '/packs/new', to: 'packs#new', as: :new_pack_new
    end
    post '/', to: 'cards#check_card', as: :check_card, defaults: { format: 'js' }
    post '/users/:id', to: 'users#set_default_pack', as: :set_pack
  end

  root to: 'home/homepage#index'
end
