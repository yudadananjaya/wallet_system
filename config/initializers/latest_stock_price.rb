# config/initializers/latest_stock_price.rb
if defined?(LatestStockPrice)
    LatestStockPriceClient = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
  else
    Rails.logger.warn("LatestStockPrice class not defined")
  end
  