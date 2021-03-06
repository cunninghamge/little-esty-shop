require 'rails_helper'

RSpec.describe "Edit Item" do
  let(:merchant) {create(:merchant)}
  let(:item) {create(:item, merchant: merchant)}
  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "has a form pre-filled with the item's attributes" do
    visit edit_merchant_item_path(item)

    expect(page.find_field("item[name]").value).to eq(item.name)
    expect(page.find_field("item[description]").value).to eq(item.description)
    expect(page.find_field("item[unit_price]").value).to eq(item.unit_price.to_s)
  end

  it "edits the item's attributes" do
    visit edit_merchant_item_path(item)

    fill_in("item[name]", with: "New name")
    fill_in("item[description]", with: "New description")
    fill_in("item[unit_price]", with: 100)
    click_button("Update Item")

    expect(current_path).to eq(merchant_item_path(item))
    expect(page).to have_content("New name")
    expect(page).to have_content("Description: New description")
    expect(page).to have_content("Price: 100")
    expect(page).to have_content("Item has been updated!")
  end
end
