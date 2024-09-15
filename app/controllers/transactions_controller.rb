class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :find_wallets, only: [:create]
    before_action :set_transaction, only: [:show]
    before_action :set_wallet, only: [:wallet_transactions]
  
    # POST /transactions
    def create
      transaction_type = params[:transaction][:transaction_type]
  
      if valid_transaction_type?(transaction_type)
        ActiveRecord::Base.transaction do
          create_transaction(transaction_type)
        end
        render json: { message: "Transaction successfully processed" }, status: :ok
      else
        render json: { error: "Invalid transaction type" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Source or target wallet not found" }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  
    # GET /transactions
    def index
      @transactions = Transaction.all
      render json: @transactions.as_json(
        only: [:id, :amount, :transaction_type, :source_wallet_id, :target_wallet_id, :created_at]
      )
    end
  
    # GET /transactions/:id
    def show
      render json: @transaction.as_json(
        only: [:id, :amount, :transaction_type, :source_wallet_id, :target_wallet_id, :created_at]
      )
    end
  
    # GET /wallets/:wallet_id/transactions
    def wallet_transactions
      @transactions = @wallet.transactions
      render json: @transactions.as_json(
        only: [:id, :amount, :transaction_type, :source_wallet_id, :target_wallet_id, :created_at]
      )
    end
  
    private
  
    def transaction_params
      params.require(:transaction).permit(:amount, :source_wallet_id, :target_wallet_id, :transaction_type)
    end
  
    def find_wallets
      @source_wallet = Wallet.find_by(id: transaction_params[:source_wallet_id])
      @target_wallet = Wallet.find_by(id: transaction_params[:target_wallet_id])
    end
  
    def valid_transaction_type?(type)
      %w[CreditTransaction DebitTransaction TransferTransaction].include?(type)
    end
  
    def create_transaction(type)
      amount = transaction_params[:amount].to_f
  
      case type
      when 'CreditTransaction'
        raise "Target wallet not specified" unless @target_wallet
        CreditTransaction.create!(amount: amount, target_wallet: @target_wallet)
      when 'DebitTransaction'
        raise "Source wallet not specified" unless @source_wallet
        raise "Insufficient funds in source wallet" if @source_wallet.balance < amount
        DebitTransaction.create!(amount: amount, source_wallet: @source_wallet)
      when 'TransferTransaction'
        raise "Source wallet not specified" unless @source_wallet
        raise "Target wallet not specified" unless @target_wallet
        raise "Insufficient funds in source wallet" if @source_wallet.balance < amount
        TransferTransaction.create!(amount: amount, source_wallet: @source_wallet, target_wallet: @target_wallet)
      end
    end
  
    def set_transaction
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Transaction not found' }, status: :not_found
    end
  
    def set_wallet
      @wallet = Wallet.find(params[:wallet_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end
  