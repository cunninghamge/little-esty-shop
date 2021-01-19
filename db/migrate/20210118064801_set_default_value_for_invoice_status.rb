class SetDefaultValueForInvoiceStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :invoices, :status, from: nil, to: 0
    change_column_default :invoice_items, :status, from: nil, to: 0
  end
end
