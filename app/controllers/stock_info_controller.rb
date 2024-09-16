class StockInfoController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index, :filtered]
  before_action :set_stock_info_service

  # GET /stock_info
  def index
    all_stock_complete_info = @stock_info_service.fetch_all_stock_complete_info
    render json: all_stock_complete_info
  end

  # POST /stock_info/filtered
  def filtered
    symbols = params[:symbols]
    specific_stock_complete_info = @stock_info_service.fetch_specific_stock_complete_info(symbols)
    render json: specific_stock_complete_info
  end

  private

  def set_stock_info_service
    @stock_info_service = LatestStockInfo.new(ENV['RAPIDAPI_KEY'])
  end
end
