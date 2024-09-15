class StockPriceController < ApplicationController
    def index
      service = StockPriceService.new
      
      case params[:type]
      when 'price'
        render json: service.fetch_price(params[:symbol])
      when 'prices'
        render json: service.fetch_prices(params[:symbols].split(','))
      when 'price_all'
        render json: service.fetch_price_all
      else
        render json: { error: 'Invalid type' }, status: :bad_request
      end
    end
  end
  