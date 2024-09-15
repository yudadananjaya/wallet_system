class StockPriceService
    def initialize
      @library = LatestStockPrice.new(ENV['RAPIDAPI_KEY'])
    end
  
    def fetch_price(symbol)
      @library.price(symbol)
    end
  
    def fetch_prices(symbols)
      @library.prices(symbols)
    end
  
    def fetch_price_all
      @library.price_all
    end
  end
  