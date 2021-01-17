class Admin::DashboardController < ApplicationController
  def index
    @customers = Customer.top_customers(5)
    @incomplete_invoices = Invoice.incomplete_invoices
  end
end
