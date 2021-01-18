class Merchant::ItemsController < Merchant::BaseController
  before_action :get_item, only: [:show, :edit, :update, :enable]
  before_action :get_merchant, only: [:index, :new, :create]

  def index
    @items = @merchant.items
  end

  def update
    @item.update(item_params)
    flash[:notice] = "Item has been updated!"
    redirect_to merchant_item_path(@item)
  end

  def enable
    @item.update(item_params)
    redirect_to merchant_items_path(params[:merchant_id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = @merchant.items.new(item_params.merge(enabled: false))
    if @item.save
      flash[:notice] = "Successfully Added Item"
      redirect_to merchant_items_path
    else
      flash[:errors] = @item.errors.full_messages
      render :new, obj: [@merchant, @item]
    end
  end

  private
  def get_item
    @item = Item.find(params[:id])
  end

  def get_merchant
    @merchant = current_user.merchant
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :enabled)
  end
end
