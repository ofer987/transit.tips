Rails.application.routes.draw do
  resources :statuses, only: [:index]
end
