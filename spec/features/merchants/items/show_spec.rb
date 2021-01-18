require 'rails_helper'

RSpec.describe "Items Index" do
  let(:merchant) {create(:merchant)}
  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'displays' do
    it "the item's attributes" do
      item = create(:item, merchant: merchant)

      visit merchant_item_path(item)

      expect(page).to have_content(item.name)
      expect(page).to have_content("Description: #{item.description}")
      expect(page).to have_content("Price: #{item.unit_price}")
    end

    it "a link to update the item" do
      item = create(:item, merchant: merchant)

      visit merchant_item_path(item)

      expect(page).to have_link("Update", href: edit_merchant_item_path(item))
    end
  end
end
