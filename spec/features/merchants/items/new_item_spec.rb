require 'rails_helper'

RSpec.describe "New Item" do
  let(:merchant) {create(:merchant)}
  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "creates a new item" do
    visit new_merchant_item_path

    fill_in("item[name]", with: "LOUD ONION")
    fill_in("item[description]", with: "makes u cry")
    fill_in("item[unit_price]", with: 100)
    click_button("Create")

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("LOUD ONION")
    expect(page).to have_button("Enable")
  end

  it "does not allow creation of incomplete items" do
    visit new_merchant_item_path

    click_button("Create")

    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Unit price can't be blank")
  end
end
