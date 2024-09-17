# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_16_102855) do
  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "session_token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_token"], name: "index_sessions_on_session_token", unique: true
  end

  create_table "stock_equities", force: :cascade do |t|
    t.integer "wallet_id", null: false
    t.string "symbol", null: false
    t.integer "quantity", default: 0
    t.decimal "price", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_id"], name: "index_stock_equities_on_wallet_id"
  end

  create_table "stock_transactions", force: :cascade do |t|
    t.integer "wallet_id", null: false
    t.integer "stock_equity_id", null: false
    t.decimal "price", precision: 15, scale: 2
    t.integer "quantity"
    t.integer "transaction_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_equity_id"], name: "index_stock_transactions_on_stock_equity_id"
    t.index ["wallet_id"], name: "index_stock_transactions_on_wallet_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "source_wallet_id"
    t.integer "target_wallet_id"
    t.decimal "amount", precision: 15, scale: 2
    t.integer "transaction_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["source_wallet_id"], name: "index_transactions_on_source_wallet_id"
    t.index ["target_wallet_id"], name: "index_transactions_on_target_wallet_id"
    t.index ["type"], name: "index_transactions_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string "walletable_type", null: false
    t.integer "walletable_id", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["walletable_type", "walletable_id"], name: "index_wallets_on_walletable"
  end

  add_foreign_key "stock_equities", "wallets"
  add_foreign_key "stock_transactions", "stock_equities"
  add_foreign_key "stock_transactions", "wallets"
  add_foreign_key "transactions", "wallets", column: "source_wallet_id"
  add_foreign_key "transactions", "wallets", column: "target_wallet_id"
end
