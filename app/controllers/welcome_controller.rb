class WelcomeController < ApplicationController
  def index
    @items = Item.enabled
  end
end
