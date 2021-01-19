class InvoicesController < ApplicationController
  def create
    customer = Customer.find(current_user.customer_id)
    invoice = customer.invoices.create
    invoice.populate(cart.contents)
    session.delete(:cart)
    flash[:notice] = "Order Submitted"
    redirect_to root_path
  end
end
