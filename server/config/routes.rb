Rails.application.routes.draw do
  get 'lines/index'

  get 'lines/show'

  resources :statuses, only: [:index]
end
