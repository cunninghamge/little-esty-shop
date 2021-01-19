require 'rails_helper'

RSpec.describe "checking out" do
  describe "checkout button" do
    it "users see a button to check out" do
      cart = Cart.new({'1'=> 2, '2'=>3})
      allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
      visit root_path

      expect(page).to have_button("Check Out")
    end

    it "does not allow the user to check out if the cart is empty" do
      visit root_path

      expect(page).not_to have_button("Check Out")
    end
  end

  it "creates an invoice and invoice_items" do
    item = create(:item)
    cart = Cart.new({"#{item.id}"=> 1})
    customer = create(:customer)
    user = create(:user, role: 0, customer: customer)
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit root_path

    click_button("Check Out")

    expect(page).to have_content("Order Submitted")
    expect(customer.invoices.count).to eq(1)
    expect(customer.invoices[0].invoice_items.count).to eq(1)
  end
end
