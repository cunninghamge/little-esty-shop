require 'rails_helper'

RSpec.describe "adding items to cart" do
  it "users can add a single item to their cart" do
    item = create(:item, enabled: true)

    visit items_path

    within("#item-#{item.id}") {click_button("Add to Cart")}

    expect(page).to have_content("My Cart (1)")
  end

  it "users can select a quantity" do
    item = create(:item, enabled: true)

    visit items_path

    within("#item-#{item.id}") do
      select(2, from: :quantity)
      click_button("Add to Cart")
    end

    expect(page).to have_content("My Cart (1)")
  end

  it "users can add multiple different items" do
    item_1 = create(:item, enabled: true)
    item_2 = create(:item, enabled: true)

    visit items_path

    within("#item-#{item_1.id}") {click_button("Add to Cart")}
    within("#item-#{item_2.id}") {click_button("Add to Cart")}

    expect(page).to have_content("My Cart (2)")
  end
end
