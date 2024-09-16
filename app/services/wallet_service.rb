class WalletService
    def self.transfer_funds(source_wallet, target_wallet, amount)
      ApplicationRecord.transaction do
        raise "Insufficient funds" if source_wallet.balance < amount
  
        source_wallet.update!(balance: source_wallet.balance - amount)
        target_wallet.update!(balance: target_wallet.balance + amount)
  
        Transaction.create!(
          source_wallet: source_wallet,
          target_wallet: target_wallet,
          amount: amount,
          transaction_type: :debit
        )
      end
    end
  end
  