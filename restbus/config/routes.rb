Rails.application.routes.draw do
  resources :agencies, only: :show do
    resources :routes, only: %i[index show] do
      resource :stops, only: :show do
        resources :predictions, only: :index
      end
    end
  end

  get 'nearby/index'

  root 'nearby#index'
end
