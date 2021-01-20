require "rails_helper"

RSpec.describe "Merchant Invoices index" do
  let(:merchant) {create(:merchant)}

  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "Displays" do
    it "invoices that have merchant's items" do
      items = create_list(:item, 5, merchant: merchant, unit_price: 1)

      5.times do |index|
        invoice = create(:invoice, created_at: Date.today - index)
        items[index..-1].each do |item|
          create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
        end
      end

      visit merchant_invoices_path

      expect(page).to have_css("#invoice-5")

      Invoice.all.each do |i|
        expect(page).to have_link("#{i.id}", href: merchant_invoice_path(i))
      end
    end
  end
end
