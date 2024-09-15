class StockPricesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:multiple]

  def show
    stock_price_service = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
    symbol = params[:symbol]
    price = stock_price_service.price(symbol)
    render json: price
  end

  def index
    stock_price_service = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
    symbols = params[:symbols].split(',')
    prices = stock_price_service.prices(symbols)
    render json: prices
  end

  def multiple
    stock_price_service = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
    symbols = params[:symbols].split(',')
    prices = stock_price_service.prices(symbols)
    render json: prices
  end
end
