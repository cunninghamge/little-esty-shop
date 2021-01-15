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
  end
end
