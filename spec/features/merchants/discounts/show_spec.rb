require 'rails_helper'

RSpec.describe "Discount Show" do
  let(:merchant) {create(:merchant)}

  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "displays the discount's attributes" do
    discount = create(:discount, merchant: merchant)

    visit merchant_discount_path(discount)

    expect(page).to have_content("Percentage: #{discount.percentage}%")
    expect(page).to have_content("Purchase Threshold: #{discount.threshold} items")
  end

  it "has a link to edit the discount" do
    discount = create(:discount, merchant: merchant)

    visit merchant_discount_path(discount)

    expect(page).to have_link("Edit Discount")

    click_link("Edit")

    expect(current_path).to eq(edit_merchant_discount_path(discount))
  end
end
