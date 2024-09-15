class TransferTransaction < Transaction
    after_create :transfer_amount
  
    private
  
    def transfer_amount
      source_wallet.update!(balance: source_wallet.balance - amount)
      target_wallet.update!(balance: target_wallet.balance + amount)
    end
  end
  