Rails.application.routes.draw do
  resources :statuses, only: [:index]
  resources :lines, only: [:show] do
    resources :report, only: [:index]
  end

  root to: 'statuses#index'
end
