class Transaction < ApplicationRecord
  # Ensure all subclasses are STI
  self.inheritance_column = :type

  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true

  validate :validate_wallets

  private

  def validate_wallets
    if is_a?(CreditTransaction) && target_wallet.nil?
      errors.add(:base, 'Target wallet must be present for credits')
    elsif is_a?(DebitTransaction) && source_wallet.nil?
      errors.add(:base, 'Source wallet must be present for debits')
    elsif is_a?(TransferTransaction) && (source_wallet.nil? || target_wallet.nil?)
      errors.add(:base, 'Source and target wallets must be present for transfers')
    end
  end
end
