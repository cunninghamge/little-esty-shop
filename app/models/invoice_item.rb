class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :discount, optional: true

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true
  delegate :item_price, to: :item

  def self.total_revenue
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

  def self.discount_total
    joins(:item).sum("quantity*(invoice_items.unit_price - items.unit_price)")
  end
end
