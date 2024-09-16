class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :outgoing_transactions, class_name: 'Transaction', foreign_key: :source_wallet_id
  has_many :incoming_transactions, class_name: 'Transaction', foreign_key: :target_wallet_id
  has_many :stock_equities

  def transactions
    Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", self.id, self.id)
  end
end
