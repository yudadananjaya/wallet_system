class CreateStockTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.references :stock_equity, null: false, foreign_key: true
      t.decimal :price, precision: 15, scale: 2
      t.integer :quantity
      t.integer :transaction_type, default: 0, null: false  # 0 for buy, 1 for sell

      t.timestamps
    end
  end
end
