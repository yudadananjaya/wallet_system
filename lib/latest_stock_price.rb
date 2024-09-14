# lib/latest_stock_price.rb
require 'net/http'
require 'json'

class LatestStockPrice
  BASE_URL = "https://latest-stock-price.p.rapidapi.com"

  def initialize(api_key)
    @api_key = api_key
  end

  def price(stock_symbol)
    response = request("/price/#{stock_symbol}")
    JSON.parse(response.body)
  end

  def prices(stock_symbols)
    response = request("/prices?symbols=#{stock_symbols.join(',')}")
    JSON.parse(response.body)
  end

  def price_all
    response = request("/price_all")
    JSON.parse(response.body)
  end

  private

  def request(endpoint)
    url = URI(BASE_URL + endpoint)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = @api_key
    http.request(request)
  end
end
