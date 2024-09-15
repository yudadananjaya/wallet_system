class User < ApplicationRecord
    has_secure_password
    has_one :wallet, as: :walletable, dependent: :destroy
    has_many :sessions, dependent: :destroy
end
  