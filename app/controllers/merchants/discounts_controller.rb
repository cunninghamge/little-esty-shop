class Merchants::DiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash.notice = ["Discount Successfully Added"]
      redirect_to merchant_discounts_path(@merchant)
    else
      flash.alert = @discount.errors.full_messages
      render :new, obj: [@merchant, @discount]
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
end
