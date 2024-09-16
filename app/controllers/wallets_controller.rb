class WalletsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @wallets = Wallet.all
    render json: @wallets
  end

  def show
    @wallet = Wallet.find(params[:id])
    if @wallet
      stock_equities = @wallet.stock_equities
      stock_symbols = stock_equities.pluck(:symbol)
      stock_info_details = fetch_stock_info_details(stock_symbols)
      
      stock_equities_with_details = stock_equities.map do |equity|
        stock_info = stock_info_details.find { |info| info["Symbol"] == equity.symbol }
        total_value = equity.price.to_f * equity.quantity.to_f
        {
          symbol: equity.symbol,
          quantity: equity.quantity,
          price_per_unit: equity.price,
          total_value: total_value
        }
      end
      
      total_stock_value = stock_equities_with_details.sum { |equity| equity[:total_value] }
      total_asset_value = @wallet.balance.to_f + total_stock_value

      render json: {
        wallet: {
          id: @wallet.id,
          balance: @wallet.balance,
          walletable_id: @wallet.walletable_id,
          walletable_type: @wallet.walletable_type,
          created_at: @wallet.created_at,
          updated_at: @wallet.updated_at
        },
        stock_equities: stock_equities_with_details,
        total_stock_value: total_stock_value,
        total_asset_value: total_asset_value
      }
    else
      render json: { error: "Wallet not found" }, status: :not_found
    end
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

  def fetch_stock_info_details(symbols)
    url = URI("http://localhost:3000/stock_info/filtered?symbols=#{symbols.join(',')}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse stock info details: #{e.message}"
    []
  rescue StandardError => e
    Rails.logger.error "Failed to fetch stock info details: #{e.message}"
    []
  end
end
