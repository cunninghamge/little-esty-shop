class Merchant::InvoicesController < Merchant::BaseController
  def index
    @invoices = current_user.merchant.invoices
  end

  def show
    @merchant = current_user.merchant
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end
end
