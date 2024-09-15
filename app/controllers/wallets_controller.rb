class WalletsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @wallets = Wallet.all
    render json: @wallets
  end

  def show
    @wallet = Wallet.find(params[:id])
    render json: @wallet
  end

  def create
    @wallet = Wallet.new(wallet_params)
    if @wallet.save
      render json: @wallet, status: :created
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  def update
    @wallet = Wallet.find(params[:id])
    if @wallet.update(wallet_params)
      render json: @wallet
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:balance, :walletable_id, :walletable_type)
  end
end
