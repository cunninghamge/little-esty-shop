class ItemsController < ApplicationController
  def index
    @items = Item.enabled
    @cart = Cart.new(session[:cart])
  end
end
