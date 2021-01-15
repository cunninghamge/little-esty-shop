require 'rails_helper'

RSpec.describe "Discounts Index" do
  let(:merchant) {create(:merchant)}
  let(:visit_path) {visit merchant_discounts_path(merchant)}
  let!(:discounts) {create_list(:discount, 3, merchant: merchant)}

  describe "displays" do
    it "the merchant's discounts with their attributes" do
      visit_path

      discounts.each do |discount|
        text = "#{discount.percentage}% off orders of #{discount.threshold} or more"
        expect(page).to have_content(text)
        expect(page).to have_button("View Details")
      end

      click_button("View Details", match: :first)

      expect(current_path).to eq(discount_path(discounts.first.id))
    end

    it "link to create a new discount" do
      visit_path

      expect(page).to have_link("New Discount", href: new_merchant_discount_path(merchant))
    end

    it "links to delete discounts" do
      visit_path

      expect(page).to have_button("Delete", count: discounts.count)

      click_button("Delete", match: :first)

      expect(current_path).to eq(merchant_discounts_path(merchant))
      text = "#{discounts[0].percentage}% off orders of #{discounts[0].threshold} or more"
      expect(page).not_to have_content(text)
      expect(page).to have_content("Discount Deleted")
      expect {Discount.find(discounts[0].id)}.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
