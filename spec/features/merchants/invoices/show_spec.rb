require "rails_helper"

RSpec.describe "Merchant Invoices show" do
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  let(:merchant) {create(:merchant)}
  let(:customer) {create(:customer)}
  let(:invoice) {create(:invoice, merchant: merchant, customer: customer)}
  let!(:invoice_item) {create(:invoice_item, invoice: invoice, quantity: 5,   unit_price: 1, status: 0)}

  describe "invoice details" do
    it "invoices that have merchant's items" do
      visit merchant_invoice_path(merchant, invoice)

      expect(page).to have_content(invoice.id)
      expect(page).to have_content(format_date(invoice.created_at))
      expect(page).to have_content(invoice.status)
    end

    it "customer info" do
      visit merchant_invoice_path(merchant, invoice)

      expect(page).to have_content(name(customer))
      expect(page).to have_content(customer.address)
    end
  end

  describe "item details" do
    let(:discount_1) {create(:discount_1, merchant: merchant)}
    let!(:discounted_inv_item) {create(:invoice_item, invoice: invoice, quantity: 11, discount: discount_1)}

    it "displays detailed price info for undiscounted items" do
      visit merchant_invoice_path(merchant, invoice)

      within("#item-#{invoice_item.id}") do
        expect(page).to have_content(invoice_item.item_name)
        price = format_price(invoice_item.item_price)
        expect(page).to have_content(price)
        expect(page).to have_content(invoice_item.quantity)
        price = format_price(invoice_item.subtotal)
        expect(page).to have_content(price)
        expect(find(".discount")).to have_no_content
        price = format_price(invoice_item.total)
        expect(page).to have_content(price)
      end
    end

    it "displays detailed price info for discounted items" do
      visit merchant_invoice_path(merchant, invoice)

      within("#item-#{discounted_inv_item.id}") do
        expect(page).to have_content(discounted_inv_item.item_name)
        price = format_price(discounted_inv_item.item_price)
        expect(page).to have_content(price)
        expect(page).to have_content(discounted_inv_item.quantity)
        price = format_price(discounted_inv_item.subtotal)
        expect(page).to have_content(price)
        price = format_price(discounted_inv_item.discount_amt)
        expect(page).to have_content(price)
        expect(page).to have_link(discounted_inv_item.discount_code, href: discount_path(discount_1))
        price = format_price(discounted_inv_item.total)
        expect(page).to have_content(price)
      end
    end

    it "can alter invoice_item status" do
      visit merchant_invoice_path(merchant, invoice)

      within "#item-#{invoice_item.id}" do
        expect(page).to have_select("invoice_item[status]", selected: "pending")
        select("packaged", from: "invoice_item[status]")
        click_button "Update Item Status"

        expect(page).to have_select("invoice_item[status]", selected: "packaged")
        select("shipped", from: "invoice_item[status]")
        click_button "Update Item Status"

        expect(page).to have_select("invoice_item[status]", selected: "shipped")
        select("pending", from: "invoice_item[status]")
        click_button "Update Item Status"

        expect(page).to have_select("invoice_item[status]", selected: "pending")
      end
    end
  end

  describe "total revenue" do
    it "can display revenue without discounts" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.invoice_amount}")
    end

    xit "can display total revenue with discounts" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      discount = create(:discount, percentage: 10, threshold: 5, merchant: merchant)
      invoice = create(:invoice, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, quantity: 5, discount: discount)

      visit merchant_invoice_path(merchant, invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.invoice_amount}")
    end
  end
end
