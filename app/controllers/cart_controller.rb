class CartController < ApplicationController
  def update
    item = Item.find(params[:item_id])
    cart.add_item(item.id, params[:quantity])
    session[:cart] = cart.contents
    redirect_to root_path
  end
end
