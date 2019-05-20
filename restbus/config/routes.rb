Rails.application.routes.draw do
  namespace :ttc do
    namespace :train do
      get 'schedules/show'
    end
  end

  resources :agencies, only: :show do
    resources :routes, only: %i[index show] do
      resources :stops, only: :show do
        resources :predictions, only: :index
      end
    end
  end

  get 'nearby/index'

  root 'nearby#index'
end
