class Merchant::DashboardController < Merchant::BaseController
  def index
    @merchant = Merchant.find(params[:id])
  end
end
