class AddTypeToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :type, :string
    add_index :transactions, :type
  end
end
