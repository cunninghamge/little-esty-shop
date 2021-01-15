require 'rails_helper'

RSpec.describe "Edit Discount" do
  let(:discount) {create(:discount, percentage: 5, threshold: 5)}

  it "has a form pre-filled with the discount's attributes" do
    visit edit_discount_path(discount)

    expect(page.find_field("discount[percentage]").value).to eq(discount.percentage.to_s)
    expect(page.find_field("discount[threshold]").value).to eq(discount.threshold.to_s)
  end

  it "edits the discount's attributes" do
    visit edit_discount_path(discount)

    fill_in("discount[percentage]", with: 12)
    fill_in("discount[threshold]", with: 9)
    click_button("Update Discount")

    expect(current_path).to eq(discount_path(discount))
    expect(page).to have_content("Percentage: 12%")
    expect(page).to have_content("Purchase Threshold: 9 items")
    expect(page).to have_content("Discount has been updated!")
  end
end
