class StockTransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_wallet, only: [:buy, :sell, :by_wallet]

  def buy
    stock_info = fetch_stock_info(params[:stock_symbol])
    if stock_info.nil?
      render json: { error: "Stock symbol not found" }, status: :not_found
      return
    end

    price = select_price(stock_info, params[:price_choice])
    total_price = params[:quantity].to_i * price

    if @wallet.balance < total_price
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
      return
    end

    stock_equity = StockEquity.find_or_initialize_by(wallet: @wallet, symbol: params[:stock_symbol])
    stock_equity.quantity += params[:quantity].to_i
    stock_equity.price = price
    stock_equity.save!

    @wallet.update(balance: @wallet.balance - total_price)

    StockTransaction.create!(
      wallet: @wallet,
      stock_equity: stock_equity,
      price: price,
      quantity: params[:quantity].to_i,
      transaction_type: :buy
    )

    render json: {
      wallet: @wallet,
      stock_equity: stock_equity
    }, status: :ok
  end

  def index
    @transactions = StockTransaction.all
    render json: @transactions, status: :ok
  end

  def show
    @transaction = StockTransaction.find(params[:id])
    if @transaction
      render json: @transaction, status: :ok
    else
      render json: { error: "Transaction not found" }, status: :not_found
    end
  end

  def by_wallet
    @transactions = StockTransaction.where(wallet_id: params[:wallet_id])
    if @transactions.any?
      render json: @transactions, status: :ok
    else
      render json: { error: "No transactions found for this wallet" }, status: :not_found
    end
  end

  def sell
    stock_equity = StockEquity.find_by(wallet: @wallet, symbol: params[:stock_symbol])
    if stock_equity.nil?
      render json: { error: "Stock equity not found" }, status: :not_found
      return
    end

    stock_info = fetch_stock_info(params[:stock_symbol])
    if stock_info.nil?
      render json: { error: "Stock symbol not found" }, status: :not_found
      return
    end

    price = select_price(stock_info, params[:price_choice])
    total_sale_price = params[:quantity].to_i * price

    if stock_equity.quantity < params[:quantity].to_i
      render json: { error: "Not enough stock quantity to sell" }, status: :unprocessable_entity
      return
    end

    stock_equity.quantity -= params[:quantity].to_i
    if stock_equity.quantity.zero?
      stock_equity.destroy
    else
      stock_equity.save!
    end

    @wallet.update(balance: @wallet.balance + total_sale_price)

    StockTransaction.create!(
      wallet: @wallet,
      stock_equity: stock_equity,
      price: price,
      quantity: params[:quantity].to_i,
      transaction_type: :sell
    )

    render json: {
      wallet: @wallet,
      stock_equity: stock_equity
    }, status: :ok
  end

  private

  def fetch_stock_info(symbol)
    url = "http://localhost:3000/stock_info?symbol=#{symbol}"
    uri = URI.parse(url)
    
    # Open a TCP connection to the server
    socket = TCPSocket.open(uri.host, uri.port)
    
    # Send an HTTP GET request
    request = "GET #{uri.request_uri} HTTP/1.1\r\n" \
              "Host: #{uri.host}\r\n" \
              "Connection: close\r\n" \
              "\r\n"
    socket.print(request)
    
    # Read the response from the server
    response = socket.read
    socket.close
    
    # Split the response into headers and body
    header, body = response.split("\r\n\r\n", 2)
    
    # Parse the JSON body
    stock_data = JSON.parse(body)
    stock_data.find { |stock| stock["Symbol"] == symbol }
  rescue StandardError => e
    Rails.logger.error "Failed to fetch stock info: #{e.message}"
    nil
  end

  def select_price(stock_info, price_choice)
    case price_choice
    when "LTP"
      stock_info["LTP"].to_f
    when "High"
      stock_info["High"].to_f
    when "Low"
      stock_info["Low"].to_f
    when "P Close"
      stock_info["P Close"].to_f
    else
      raise "Invalid price choice"
    end
  end

  def find_wallet
    @wallet = Wallet.find(params[:wallet_id])
  end
end
