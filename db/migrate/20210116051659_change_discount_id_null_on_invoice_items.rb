class ChangeDiscountIdNullOnInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    change_column_null :invoice_items, :discount_id, true
  end
end
