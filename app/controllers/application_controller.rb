class ApplicationController < ActionController::Base
  before_action :call_github

  helper_method :current_user

  def call_github
    @api_info = ApiSearch.instance
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
