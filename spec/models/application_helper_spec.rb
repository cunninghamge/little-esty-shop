require 'rails_helper'

RSpec.describe "Application Helper" do
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  it 'concats customer names' do
    customer = create(:customer)

    expect(name(customer)).to eq("#{customer.first_name} #{customer.last_name}")
  end

  it "formats dates" do
    actual = format_date(Date.parse("2021-01-09"))
    expected = "Saturday, January 9, 2021"
    expect(actual).to eq(expected)
  end

  it "formats prices" do
    expected = "$148.47"
    actual = format_price(14847)
    expect(actual).to eq(expected)
  end

  it "interpolates discount details" do
    discount = create(:discount)
    expected = "#{discount.percentage}% off orders of #{discount.threshold} or more"
    actual = discount_details(discount)
    expect(actual).to eq(expected)
  end
end
