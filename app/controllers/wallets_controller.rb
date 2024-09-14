class WalletsController < ApplicationController
    # Skip CSRF protection for API requests if needed
    skip_before_action :verify_authenticity_token, only: [:create, :update]
  
    def create
      wallet = Wallet.new(wallet_params)
      if wallet.save
        render json: wallet, status: :created
      else
        render json: { errors: wallet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      wallet = Wallet.find_by(id: params[:id])
      if wallet
        render json: wallet
      else
        render json: { error: 'Wallet not found' }, status: :not_found
      end
    end
  
    def update
      wallet = Wallet.find_by(id: params[:id])
      if wallet
        if wallet.update(wallet_params)
          render json: wallet
        else
          render json: { errors: wallet.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Wallet not found' }, status: :not_found
      end
    end
  
    private
  
    def wallet_params
      params.require(:wallet).permit(:walletable_id, :walletable_type, :balance)
    end
  end
  