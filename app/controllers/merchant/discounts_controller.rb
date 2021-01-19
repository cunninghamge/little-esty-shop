class Merchant::DiscountsController < Merchant::BaseController
  before_action :get_discount, only: [:show, :edit, :update, :destroy]

  def index
    @discounts = @merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Discount Successfully Added"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:errors] = @discount.errors.full_messages
      render :new, obj: [@merchant, @discount]
    end
  end

  def update
    @discount.update(discount_params)
    flash[:notice] = "Discount has been updated!"
    redirect_to merchant_discount_path(params[:id])
  end

  def destroy
    @discount.destroy
    flash[:notice] = "Discount Deleted"
    redirect_to merchant_discounts_path
  end

  private
  def get_discount
    @discount = Discount.find(params[:id])
  end

  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
end
