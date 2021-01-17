class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    session[:user_id] = user.id
    flash[:success] = ["Welcome, #{user.username}!"]
    redirect_to root_path
  end
end
