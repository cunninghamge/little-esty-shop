class InvoicesController < ApplicationController
  def create
    merchant = Item.find(cart.contents.keys[0]).merchant
    customer = Customer.find(current_user.customer_id)
    invoice = customer.invoices.create(merchant: merchant, status: 0)
    invoice.populate(cart.contents)
    session.delete(:cart)
    flash[:notice] = "Order Submitted"
    redirect_to root_path
  end
end
