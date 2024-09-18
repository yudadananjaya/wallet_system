# app/controllers/user_controller.rb
class UserController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  # List all users
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end


  # Sign up
  def create
    @user = User.new(user_params)
    if @user.save
      @user.create_wallet # Optionally create a wallet for the new user
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # Edit profile
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # Delete account
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { message: "User account deleted" }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :gender)
  end
end
