class CartController < ApplicationController
  def update
    item = Item.find(params[:item_id])
    @cart = Cart.new(session[:cart])
    @cart.add_item(item.id, params[:quantity])
    session[:cart] = @cart.contents
    redirect_to items_path
  end
end
