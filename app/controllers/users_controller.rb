class UsersController < ApplicationController

  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.where(email:@user.email) != []
      flash[:error] = "That email address is already registered."
      render :index
    elsif @user.save
      session[:id] = @user.id
      @user.update(role: 0)
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}! You are registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = "You are missing required fields."
      render :index
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
