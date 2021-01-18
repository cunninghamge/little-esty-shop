class Admin::MerchantsController < Admin::BaseController
  before_action :get_merchant, only: [:show, :edit, :update, :enable]
  def index
    @enabled_merchants = Merchant.where(enabled: true)
    @disabled_merchants = Merchant.where(enabled: false)
    @top_merchants = Merchant.top_merchants(5)
  end

  def enable
    @merchant.update(merchant_params)
    redirect_to admin_merchants_path
  end

  def update
    if @merchant.update(merchant_params)
      flash[:notice] = "Successfully Updated Info"
      redirect_to admin_merchant_path(params[:id])
    else
      flash[:errors] = @merchant.errors.full_messages
      render "edit", obj: @merchant
    end
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      flash[:notice] = "Successfully Added Merchant"
      redirect_to admin_merchants_path
    else
      flash[:errors] = @merchant.errors.full_messages
      render "new", obj: @merchant
    end
  end

  private
  def get_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_params
    params.require(:merchant).permit(:name, :enabled)
  end
end
