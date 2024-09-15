class Session < ApplicationRecord
    belongs_to :user
  
    validates :session_token, presence: true, uniqueness: true
    validates :expires_at, presence: true
  
    # Method to check if the session is expired
    def expired?
      expires_at < Time.current
    end
end
  