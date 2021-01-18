class RemoveDiscountIdFromInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :invoice_items, :discounts
  end
end
