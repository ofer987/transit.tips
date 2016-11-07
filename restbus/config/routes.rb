Rails.application.routes.draw do
  get 'nearby/index'

  root 'nearby#index'
end
