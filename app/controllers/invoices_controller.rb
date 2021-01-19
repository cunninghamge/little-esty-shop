class InvoicesController < ApplicationController
  def create
    if current_user
      customer = Customer.find(current_user.customer_id)
      invoice = customer.invoices.create
      invoice.populate(cart.contents)
      session.delete(:cart)
      flash[:notice] = "Order Submitted"
    else
      flash[:notice] = "Please log in or create a new account"
    end
    redirect_to root_path
  end
end
