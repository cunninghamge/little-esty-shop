class ItemsController < ApplicationController
  def index
    @items = Item.enabled
  end
end
