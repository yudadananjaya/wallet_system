# lib/latest_stock_price.rb
require 'net/http'
require 'json'

class LatestStockPrice
  BASE_URL = 'https://latest-stock-price.p.rapidapi.com'

  def initialize(api_key)
    @api_key = api_key
  end

  def price(symbol)
    response = request("/price?symbol=#{symbol}")
    JSON.parse(response.body)
  end

  def prices(symbols)
    response = request("/prices?symbols=#{symbols.join(',')}")
    JSON.parse(response.body)
  end

  def price_all
    response = request('/price_all')
    JSON.parse(response.body)
  end

  private

  def request(endpoint)
    uri = URI("#{BASE_URL}#{endpoint}")
    request = Net::HTTP::Get.new(uri)
    request['X-RapidAPI-Key'] = @api_key
    request['X-RapidAPI-Host'] = 'latest-stock-price.p.rapidapi.com'
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end
end
