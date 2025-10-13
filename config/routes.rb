Rails.application.routes.draw do
  devise_for :users

  # Silence favicon errors in dev
  get '/favicon.ico', to: proc { [204, {}, []] }

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
