class CreateStockEquities < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_equities do |t|
      t.references :wallet, null: false, foreign_key: true
      t.string :symbol, null: false
      t.integer :quantity, default: 0
      t.decimal :price, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
