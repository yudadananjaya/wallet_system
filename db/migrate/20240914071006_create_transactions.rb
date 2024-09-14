class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.references :source_wallet, null: false, foreign_key: true
      t.references :target_wallet, null: false, foreign_key: true
      t.integer :transaction_type

      t.timestamps
    end
  end
end
