Rails.application.routes.draw do
  resources :statuses, only: [:index]
  resources :lines, only: [:show]

  root to: 'statuses#index'
end