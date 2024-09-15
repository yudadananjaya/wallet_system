class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  # POST /sessions
  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      # Generate a unique session token
      session_token = SecureRandom.hex(16)
      expires_at = 1.hour.from_now

      # Create session record
      session_record = user.sessions.create!(session_token: session_token, expires_at: expires_at)

      render json: { session_token: session_token, expires_at: expires_at }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /sessions
  def destroy
    session = Session.find_by(session_token: request.headers['Authorization'])

    if session
      session.destroy
      head :no_content
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
