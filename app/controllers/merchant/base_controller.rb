class Merchant::BaseController < ApplicationController
  before_action :require_merchant
  before_action :get_merchant, only: [:index, :new, :create]

  def require_merchant
    render file: "/public/404", status: 404 unless current_merchant?
  end

  def get_merchant
    @merchant = current_user.merchant
  end
end
