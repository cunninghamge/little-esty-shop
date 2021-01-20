class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :discounts

  validates :name, presence: true

  delegate :items_to_ship, to: :items
  delegate :total_revenue, to: :invoices
  delegate :top_sales_day, to: :invoices

  delegate :discounts_index, to: :discounts

  def top_customers
    Customer.joins(invoices: [:transactions, :items]).select("customers.*, count(*) as count").where(transactions: {result: 0}, items: {merchant_id: id}).group(:id).order("count"=> :desc).limit(5)
  end

  def self.top_merchants(number = 5)
    joins(invoices: :transactions)
    .where("result = 0")
    .group(:id)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .order("total_revenue" => :desc)
    .limit(number)
  end
end
