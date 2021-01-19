require 'rails_helper'

RSpec.describe "Items Index" do
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  it "lists all of the items" do
    items = create_list(:item, 3, enabled: true)
    visit root_path

    items.each do |item|
      within("#item-#{item.id}") do
        expect(page).to have_content(item.name)
        expect(page).to have_content(item.description)
        expect(page).to have_content(format_price(item.unit_price))
        expect(page).to have_select(:quantity)
        expect(page).to have_button("Add to Cart")
      end
    end
  end

  it "only lists enabled items" do
    enabled_item = create(:item, enabled: true)
    disabled_item = create(:item, enabled: false)

    visit root_path

    expect(page).to have_css("#item-#{enabled_item.id}")
    expect(page).not_to have_css("#item-#{disabled_item.id}")
  end
end
