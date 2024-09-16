class StockInfoService
    def initialize
      @library = LatestStockInfo.new(ENV['RAPIDAPI_KEY'])
    end
  
    def fetch_specific_stock_complete_info(symbols)
      @library.specific_stock_complete_info(symbols)
    end
  
    def fetch_all_stock_complete_info
      @library.all_stock_complete_info
    end
  end
  