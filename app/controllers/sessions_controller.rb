class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.username}!"
      redirect_to redirect_path
    else
      flash[:alert] = "Invalid username or password"
      render :new
    end
  end

  def delete
    session.delete(:user_id)
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end

  private
  def redirect_path
    if current_admin?
      admin_path
    elsif current_merchant?
      merchant_dashboard_path(current_user.merchant)
    else
      root_path
    end
  end
end
