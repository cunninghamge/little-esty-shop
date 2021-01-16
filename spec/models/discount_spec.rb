require 'rails_helper'

RSpec.describe Discount do
  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :threshold}
  end

  describe "instance methods" do
    it "#discount_code" do
      merchant = create(:merchant, id: 90)
      allow(Time).to receive(:now).and_return(DateTime.parse("2020-12-30"))
      discount = create(:discount, merchant: merchant)

      expect(discount.discount_code).to eq("B9011220")
    end
  end
end
