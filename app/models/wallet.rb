class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :transactions, foreign_key: :source_wallet_id
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
