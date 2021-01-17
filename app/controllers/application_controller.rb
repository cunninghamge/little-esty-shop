class ApplicationController < ActionController::Base
  before_action :call_github

  helper_method :current_user, :current_admin?, :current_merchant?

  def call_github
    @api_info = ApiSearch.instance
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end
end
