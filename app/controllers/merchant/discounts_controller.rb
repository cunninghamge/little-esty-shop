class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = current_user.merchant
    @discount = Discount.new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Discount Successfully Added"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:errors] = @discount.errors.full_messages
      render :new, obj: [@merchant, @discount]
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    Discount.find(params[:id]).update(discount_params)
    flash[:notice] = "Discount has been updated!"
    redirect_to merchant_discount_path(params[:id])
  end

  def destroy
    Discount.find(params[:id]).destroy
    flash[:notice] = "Discount Deleted"
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
end
