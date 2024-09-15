Rails.application.routes.draw do
  resources :sessions, only: [:create, :destroy]

  # Define routes for Wallets
  resources :wallets, only: [:index, :show, :create, :update] do
    # Route for transactions in a specific wallet
    get 'transactions', to: 'transactions#wallet_transactions', as: 'transactions'
  end

  # Define routes for Transactions
  resources :transactions, only: [:index, :show, :create]

  # Define routes for Stock Price API
  get 'stock_price', to: 'stock_price#index'

  # Define route for Sessions (login)
  post 'sessions', to: 'sessions#create'
  delete 'sessions', to: 'sessions#destroy'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
