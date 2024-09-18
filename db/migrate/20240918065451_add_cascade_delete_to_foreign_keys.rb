class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :transactions, :wallets, column: :source_wallet_id
    remove_foreign_key :transactions, :wallets, column: :target_wallet_id

    add_foreign_key :transactions, :wallets, column: :source_wallet_id, on_delete: :cascade
    add_foreign_key :transactions, :wallets, column: :target_wallet_id, on_delete: :cascade
  end
end
