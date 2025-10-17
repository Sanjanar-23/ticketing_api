Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations',
    passwords: 'passwords'
  }

  # Silence favicon errors in dev
  get '/favicon.ico', to: proc { [204, {}, []] }

  root to: 'dashboard#index'

  resources :companies
  resources :contacts
  resources :tickets do
    resources :ticket_emails, only: [:create, :show]
  end
  resources :chatbots, only: [:index, :create] do
    collection do
      get :chat_history
    end
    member do
      patch :feedback
    end
  end

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
