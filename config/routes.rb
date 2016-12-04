Rails.application.routes.draw do
  root to: 'homepage#index'

  resources :cards
  post '/', to: 'cards#check_card', as: :check_card
end
