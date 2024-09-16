if defined?(LatestStockInfo)
    LatestStockInfoClient = LatestStockInfo.new(ENV['RAPIDAPI_KEY'])
  else
    Rails.logger.warn("LatestStockInfo class not defined")
  end
  