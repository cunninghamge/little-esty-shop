class Merchant::InvoicesController < Merchant::BaseController
  before_action :get_merchant

  def index
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end
end
