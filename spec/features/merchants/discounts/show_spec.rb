require 'rails_helper'

RSpec.describe "Discount Show" do
  it "displays the discount's attributes" do
    discount = create(:discount)

    visit discount_path(discount)

    expect(page).to have_content("Percentage: #{discount.percentage}%")
    expect(page).to have_content("Purchase Threshold: #{discount.threshold} items")
  end
end
