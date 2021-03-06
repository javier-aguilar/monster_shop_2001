class SessionsController < ApplicationController

  def new
    if logged_in?
      flash[:error] = "I'm already logged in"
      redirect_by_role
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_by_role
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "Successfully logged out!"
    redirect_to "/"
  end

  private

  def redirect_by_role
    redirect_to '/merchant' if current_merchant?
    redirect_to '/admin' if current_admin?
    redirect_to '/profile' if current_user?
  end
end
