class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = ["Welcome, #{user.username}!"]
      redirect_to root_path
    else
      flash[:error] = ["Invalid username or password"]
      render :new
    end
  end

  def delete
    session.delete(:user_id)
    flash[:success] = ["Successfully logged out"]
    redirect_to root_path
  end
end