require 'net/http'
require 'json'
require 'uri'  # Make sure URI is required if you are using it for URL encoding

class LatestStockInfo
  BASE_URL = 'https://latest-stock-price.p.rapidapi.com'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_all_stock_complete_info
    response = request('/equities')
    JSON.parse(response.body)
  end

  def fetch_specific_stock_complete_info(symbols)
    symbols_string = symbols.join(',')  # "ZOMA.NS,TATADVRA.NS"
    encoded_symbols = URI.encode_www_form_component(symbols_string)  # "ZOMA.NS%2CTATADVRA.NS"
    response = request("/equities-enhanced?Symbols=#{encoded_symbols}")
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
