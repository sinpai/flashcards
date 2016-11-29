Rails.application.routes.draw do
  root to: 'homepage#index'

  get "cards" => 'cards#index'
  resources :cards
  # controller :cards do
  #   get 'new' => :new
  #   post 'new' => :create
  # end
end
