class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer

  enum status: ['in progress', 'completed', 'cancelled']

  delegate :revenue, to: :invoice_items

  def populate(cart_contents)
    cart_contents.each do |item_id, quantity|
      self.invoice_items.create(item_id: item_id, quantity: quantity)
    end
  end

  def self.incomplete_invoices
    where(status: "in progress").order(created_at: :asc)
  end

  def self.top_sales_day
    joins(:transactions).where(transactions: {result: 0})
    .select("CAST (invoices.created_at AS DATE), sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:created_at)
    .order("revenue"=> :desc, :created_at=> :desc)
    .first.created_at
  end

  def self.total_revenue
    joins(:transactions)
    .where(transactions: {result: 0})
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
