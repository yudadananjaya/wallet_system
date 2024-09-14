class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { message: 'Logged in successfully' }
      else
        render json: { message: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    def destroy
      session[:user_id] = nil
      render json: { message: 'Logged out' }
    end
end
  