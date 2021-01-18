require 'rails_helper'

RSpec.describe "Items Index" do
  it "lists all of the items" do
    items = create_list(:item, 3)
    visit items_path

    items.each do |item|
      within("#item-#{item.id}") do
        expect(page).to have_content(item.name)
        expect(page).to have_content(item.description)
        expect(page).to have_content(item.price)
        expect(page).to have_select(:quantity)
        expect(page).to have_button("Add to Cart")
      end
    end
  end
end
