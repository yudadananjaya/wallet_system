# app/controllers/stock_prices_controller.rb
class StockPricesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:multiple]
  before_action :set_stock_price_service

  # GET /stock_prices/:symbol
  def show
    symbol = params[:symbol]
    price = @stock_price_service.price(symbol)
    render json: price
  end

  # GET /stock_prices
  def index
    prices = @stock_price_service.price_all
    render json: prices
  end

  # POST /stock_prices/multiple
  def multiple
    symbols = params[:symbols]
    prices = @stock_price_service.prices(symbols)
    render json: prices
  end

  private

  def set_stock_price_service
    @stock_price_service = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
  end
end
