require 'rails_helper'

RSpec.describe "checking out" do
  it "users see a button to check out" do
    cart = Cart.new({'1'=> 2, '2'=>3})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit items_path

    expect(page).to have_button("Check Out")
  end

  it "does not allow the user to check out if the cart is empty" do
    visit items_path

    expect(page).not_to have_button("Check Out")
  end
end
