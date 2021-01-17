require 'rails_helper'

RSpec.describe "Discounts Index" do
  let(:merchant) {create(:merchant)}
  let!(:discounts) {create_list(:discount, 3, merchant: merchant)}
  let(:visit_path) {visit merchant_discounts_path}

  before(:each) do
    user = create(:user, role: 1, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "displays" do
    it "the merchant's discounts with their attributes" do
      visit_path

      discounts.each do |discount|
        text = "#{discount.percentage}% off orders of #{discount.threshold} or more"
        expect(page).to have_content(text)
        expect(page).to have_button("View Details")
      end

      click_button("View Details", match: :first)

      expect(current_path).to eq(merchant_discount_path(discounts.first))
    end

    it "link to create a new discount" do
      visit_path

      expect(page).to have_link("New Discount", href: new_merchant_discount_path)
    end

    it "links to delete discounts" do
      visit_path

      expect(page).to have_button("Delete", count: discounts.count)

      discount = discounts[0]
      within("#discount-#{discount.id}") {click_button("Delete")}

      expect(current_path).to eq(merchant_discounts_path)

      expect(page).to have_content("Discount Deleted")
      expect {Discount.find(discount.id)}.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
