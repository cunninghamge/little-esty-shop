require "rails_helper"

RSpec.describe "Merchant Invoices show" do
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  let!(:merchant) {create(:merchant)}
  let!(:customer) {create(:customer)}
  let!(:item) {create(:item, merchant: merchant, unit_price: 100)}
  let!(:invoice) {create(:invoice, merchant: merchant, customer: customer)}
  let!(:invoice_item) {create(:invoice_item, invoice: invoice, quantity: 5, item: item, unit_price: 100, status: 0)}

  let!(:discount_1) {create(:discount, merchant: merchant, threshold: 10, percentage: 20)}
  let!(:discounted_inv_item) {create(:invoice_item, invoice: invoice, item: item, quantity: 10, unit_price: 80, discount: discount_1)}

  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  let!(:invoice_items) {InvoiceItem.all}

  describe "invoice details" do
    it "invoices that have merchant's items" do
      visit merchant_invoice_path(invoice)

      expect(page).to have_content(invoice.id)
      expect(page).to have_content(format_date(invoice.created_at))
      expect(page).to have_content(invoice.status)
    end

    it "customer info" do
      visit merchant_invoice_path(invoice)

      expect(page).to have_content(name(customer))
      expect(page).to have_content(customer.address)
    end
  end

  describe "item details" do
    it "displays detailed price info for undiscounted items" do
      visit merchant_invoice_path(invoice)

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
      visit merchant_invoice_path(invoice)

      within("#item-#{discounted_inv_item.id}") do
        expect(page).to have_content(discounted_inv_item.item_name)
        price = format_price(discounted_inv_item.item_price)
        expect(page).to have_content(price)
        expect(page).to have_content(discounted_inv_item.quantity)
        price = format_price(discounted_inv_item.subtotal)
        expect(page).to have_content(price)
        price = format_price(discounted_inv_item.discount_amt)
        expect(page).to have_content(price)
        expect(page).to have_link(discount_details(discount_1), href: merchant_discount_path(discount_1))
        price = format_price(discounted_inv_item.total)
        expect(page).to have_content(price)
      end
    end

    it "can alter invoice_item status" do
      visit merchant_invoice_path(invoice)

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
    it "displays the total revenue for the invoice" do
      visit merchant_invoice_path(invoice)

      expect(page).to have_content("Total Revenue: #{format_price(invoice.total_revenue)}")
    end

    it "includes the total amount of discounts applied" do
      visit merchant_invoice_path(invoice)

      within("tr.total") do
        expect(page).to have_content(format_price(invoice_items.discount_total))
        expect(page).to have_content(format_price(invoice_items.total_revenue))
      end
    end
  end
end
