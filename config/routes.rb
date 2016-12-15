Rails.application.routes.draw do

  root to: 'homepage#index'

  resources :cards
  resources :users
  resources :user_sessions

  post '/', to: 'cards#check_card', as: :check_card
  post '/cards/:id/add', to: 'cards#add', as: :add_card
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
