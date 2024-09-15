class ChangeTransactionTypeToIntegerInTransactions < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :transaction_type, :integer, default: 0, null: false
  end
end
