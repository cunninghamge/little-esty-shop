class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :discount, optional: true

  enum status: ["pending", "packaged", "shipped"]

  after_create :get_discount, :set_unit_price

  delegate :name, to: :item, prefix: true
  delegate :item_price, to: :item

  def get_discount
    self.discount = Discount.where(merchant_id: item.merchant_id).where("threshold <= ?", quantity).order(percentage: :desc).first
  end

  def set_unit_price
    if discount_id
      self.unit_price = item.unit_price*(1 - discount.percentage/100.0)
    else
      self.unit_price = item.unit_price
    end
  end

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
