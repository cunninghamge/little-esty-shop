require 'rails_helper'

RSpec.describe "Edit Discount" do
  before(:each) do
    @merchant = create(:merchant)
    user = create(:user, role: 1, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  let(:discount) {create(:discount, merchant: @merchant, percentage: 5, threshold: 5)}

  it "has a form pre-filled with the discount's attributes" do
    visit edit_merchant_discount_path(discount)

    expect(page.find_field("discount[percentage]").value).to eq(discount.percentage.to_s)
    expect(page.find_field("discount[threshold]").value).to eq(discount.threshold.to_s)
  end

  it "edits the discount's attributes" do
    visit edit_merchant_discount_path(discount)

    fill_in("discount[percentage]", with: 12)
    fill_in("discount[threshold]", with: 9)
    click_button("Update Discount")

    expect(current_path).to eq(merchant_discount_path(discount))
    expect(page).to have_content("Percentage: 12%")
    expect(page).to have_content("Purchase Threshold: 9 items")
    expect(page).to have_content("Discount has been updated!")
  end
end
