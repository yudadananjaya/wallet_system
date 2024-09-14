class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :validate_transaction_type

  enum transaction_type: { credit: 0, debit: 1 }

  def validate_transaction_type
    if credit? && source_wallet.present?
      errors.add(:source_wallet, "must be nil for credit transactions")
    elsif debit? && target_wallet.present?
      errors.add(:target_wallet, "must be nil for debit transactions")
    end
  end
end
