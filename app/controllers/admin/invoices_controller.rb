class Admin::InvoicesController < Admin::BaseController
  before_action :get_invoice, only: [:show, :update]
  
  def index
    @invoices = Invoice.order(:id)
  end

  def show
    @merchant = @invoice.merchant
    @invoice_items = @invoice.invoice_items
  end

  def update
    @invoice.update(invoice_params)
    redirect_to admin_invoice_path(invoice)
  end

  private
  def get_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.permit(:status)
  end
end
