User.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all
Item.destroy_all
Invoice.destroy_all
Discount.destroy_all
Customer.destroy_all
Merchant.destroy_all

created_at = 1.year.ago
merchant_users = []
User.create(username: "admin", password: "admin", role: 2)
merchant_users << FactoryBot.create(:merchant, id: 1, created_at: created_at)
User.create(username: "merchant_1", password: "merchant", role: 1, merchant_id: 1)
merchant_users << FactoryBot.create(:merchant, id: 2, created_at: created_at)
User.create(username: "merchant_2", password: "merchant", role: 1, merchant_id: 2)
merchant_users << FactoryBot.create(:merchant, id: 3, created_at: created_at)
User.create(username: "merchant_3", password: "merchant", role: 1, merchant_id: 3)
FactoryBot.create(:customer, id: 1, created_at: created_at)
User.create(username: "customer", password: "customer", role: 0, customer_id: 1)

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

FactoryBot.create_list(:customer, 199)

#in progress orders with successful transaction, no items shipped
merchant_users.each do |merchant|
  10.times do
    invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
    2.times do
      FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at)
    end
    FactoryBot.create(:transaction, invoice: invoice, result: 0)
  end
end
100.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with successful transaction, some items shipped
merchant_users.each do |merchant|
  15.times do
    invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
    2.times do
      FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
    end
    FactoryBot.create(:transaction, invoice: invoice, result: 0)
  end
end
150.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..10).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with multiple transactions, no items shipped
merchant_users.each do |merchant|
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  2.times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with multiple transactions, some items shipped
merchant_users.each do |merchant|
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  2.times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: rand(0..2))
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#in progress orders with failed transaction, no items shipped
merchant_users.each do |merchant|
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  2.times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
end
10.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(1..30).days.ago)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
end

#completed orders
merchant_users.each do |merchant|
  20.times do
    invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
    2.times do
      FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at, status: 2)
    end
    FactoryBot.create(:transaction, invoice: invoice, result: 0)
  end
end
1000.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: 2)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#completed orders w/ multiple transactions
merchant_users.each do |merchant|
  3.times do
    invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
    2.times do
      FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at, status: 2)
    end
    FactoryBot.create(:transaction, invoice: invoice, result: 1)
    FactoryBot.create(:transaction, invoice: invoice, result: 0)
  end
end
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 1)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at, status: 2)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
  FactoryBot.create(:transaction, invoice: invoice, result: 0)
end

#cancelled orders
merchant_users.each do |merchant|
  3.times do
    invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 2)
    2.times do
      FactoryBot.create(:invoice_item, invoice: invoice, item: merchant.items.order('random()').first, created_at: invoice.created_at)
    end
    FactoryBot.create(:transaction, invoice: invoice, result: 1)
  end
end
30.times do
  invoice = FactoryBot.create(:invoice, customer: Customer.order('random()').first, created_at: rand(2..364).days.ago, status: 2)
  rand(1..6).times do
    FactoryBot.create(:invoice_item, invoice: invoice, item: Item.order('random()').first, created_at: invoice.created_at)
  end
  FactoryBot.create(:transaction, invoice: invoice, result: 1)
end
