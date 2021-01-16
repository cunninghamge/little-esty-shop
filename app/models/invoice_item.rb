class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :discount, optional: true

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true
  delegate :item_price, to: :item
  delegate :discount_code, to: :discount

  def self.invoice_amount
    sum('quantity * unit_price')
  end

  def subtotal
    item_price * quantity
  end

  def total
    unit_price * quantity
  end

  def discount_amt
    total - subtotal
  end
end
