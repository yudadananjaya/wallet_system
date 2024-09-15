class DebitTransaction < Transaction
    after_create :debit_wallet
  
    private
  
    def debit_wallet
      source_wallet.update!(balance: source_wallet.balance - amount)
    end
  end
  