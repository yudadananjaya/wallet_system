Rails.application.routes.draw do
  resources :sessions, only: [:create, :destroy]

  resources :user, only: [:index, :show, :create, :update, :destroy]

  # Define routes for Wallets
  resources :wallets, only: [:index, :show, :create, :update] do
    # Route for transactions in a specific wallet
    get 'transactions', to: 'transactions#wallet_transactions', as: 'transactions'
  end

  # Define routes for Transactions
  resources :transactions, only: [:index, :show, :create]

  # Stock Transactions
  post 'stock_transactions/buy', to: 'stock_transactions#buy'
  post 'stock_transactions/sell', to: 'stock_transactions#sell'

  # Define routes for Stock Info
  get 'stock_info', to: 'stock_info#index'
  post 'stock_info/filtered', to: 'stock_info#filtered'

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

  # Route for fetching all stock transactions
  get 'stock_transactions', to: 'stock_transactions#index', as: 'all_stock_transactions'

  # Route for fetching stock transactions by wallet ID
  get 'wallets/:wallet_id/stock_transactions', to: 'stock_transactions#by_wallet', as: 'wallet_stock_transactions'

  # Route for fetching a specific stock transaction by ID
  get 'stock_transactions/:id', to: 'stock_transactions#show', as: 'stock_transaction'

end
