class User < ApplicationRecord
    has_secure_password
    has_one :wallet, as: :walletable, dependent: :destroy
    has_many :sessions, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :gender, inclusion: { in: %w[male female other], message: "%{value} is not a valid gender" }
end
  