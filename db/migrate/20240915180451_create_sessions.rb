class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :sessions, :session_token, unique: true
  end
end
