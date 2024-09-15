class CreditTransaction < Transaction
    after_create :credit_wallet
  
    private
  
    def credit_wallet
      target_wallet.update!(balance: target_wallet.balance + amount)
    end
end
  