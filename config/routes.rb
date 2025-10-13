Rails.application.routes.draw do
  devise_for :users

  root to: 'companies#index'

  resources :companies
  resources :contacts
  resources :tickets

  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'

      resources :users
      resources :companies
      resources :contacts
      resources :tickets
    end
  end
end
