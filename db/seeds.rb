# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all
Item.destroy_all
Invoice.destroy_all
Discount.destroy_all
Customer.destroy_all
Merchant.destroy_all

created_at = 1.year.ago

User.create(username: "admin", password: "admin", role: 2)
FactoryBot.create(:merchant, id: 1, created_at: created_at)
User.create(username: "merchant_1", password: "merchant", role: 1, merchant_id: 1)
FactoryBot.create(:merchant, id: 2, created_at: created_at)
User.create(username: "merchant_2", password: "merchant", role: 1, merchant_id: 2)
FactoryBot.create(:merchant, id: 3, created_at: created_at)
User.create(username: "merchant_3", password: "merchant", role: 1, merchant_id: 3)
FactoryBot.create(:customer, id: 1, created_at: created_at)
User.create(username: "customer_1", password: "customer", role: 0, customer_id: 1)
FactoryBot.create(:customer, id: 2, created_at: created_at)
User.create(username: "customer_2", password: "customer", role: 0, customer_id: 2)
FactoryBot.create(:customer, id: 3, created_at: created_at)
User.create(username: "customer_3", password: "customer", role: 0, customer_id: 3)

FactoryBot.create_list(:item, rand(2..30), merchant_id: 1, created_at: created_at)
FactoryBot.create_list(:discount, rand(0..3), merchant_id: 1, created_at: created_at)
FactoryBot.create_list(:item, rand(2..30), merchant_id: 2, created_at: created_at)
FactoryBot.create_list(:discount, rand(0..3), merchant_id: 1, created_at: created_at)
FactoryBot.create_list(:item, rand(2..30), merchant_id: 3, created_at: created_at)
FactoryBot.create_list(:discount,rand(0..3), merchant_id: 1, created_at: created_at)

97.times do
  merchant = FactoryBot.create(:merchant)
  FactoryBot.create_list(:item, rand(2..30), merchant: merchant)
  FactoryBot.create_list(:discount, rand(0..2), merchant: merchant)
end

FactoryBot.create_list(:customer, 197)

#in progress orders with successful transaction, no items shipped
100.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
  rand(1..6).times do
    invoice_item = FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with successful transaction, some items shipped
150.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with multiple transactions, no items shipped
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with multiple transactions, some items shipped
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with failed transaction, no items shipped
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
end

#completed orders
1000.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: 2)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#completed orders w/ multiple transactions
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: 2)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#cancelled orders
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 2)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end
