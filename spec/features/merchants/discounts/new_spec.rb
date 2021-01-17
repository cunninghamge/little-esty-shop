require 'rails_helper'

RSpec.describe "New Discount" do
  let(:merchant) {create(:merchant)}
  
  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "creates a new discount" do
    visit new_merchant_discount_path(merchant)

    fill_in("discount[percentage]", with: 20)
    fill_in("discount[threshold]", with: 10)
    click_button("Create")

    expect(current_path).to eq(merchant_discounts_path(merchant))
    expect(page).to have_content("20% off orders of 10 or more")
    expect(page).to have_content("Discount Successfully Added")
  end

  it "does not allow creation of incomplete discounts" do
    visit new_merchant_discount_path(merchant)

    click_button("Create")

    expect(page).to have_content("Percentage can't be blank")
    expect(page).to have_content("Threshold can't be blank")
  end
end
