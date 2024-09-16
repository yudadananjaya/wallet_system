class StockTransaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :stock_equity

  enum transaction_type: { buy: 0, sell: 1 }

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
