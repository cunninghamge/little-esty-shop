class Merchants::DiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end
end
