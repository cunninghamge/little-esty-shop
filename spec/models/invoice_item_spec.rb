require "rails_helper"

describe InvoiceItem, type: :model do
  describe "validations" do
    it {should define_enum_for(:status).with_values ["pending", "packaged", "shipped"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it {should belong_to(:discount).optional}
  end

  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end

  describe "class methods" do
    it "invoice_amount" do
      invoice = FactoryBot.create(:invoice)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, unit_price: 5) #15
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, unit_price: 5) #20
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, unit_price: 5) #25

      expect(invoice.invoice_items.invoice_amount).to eq(15+20+25)
    end
  end

  describe "instance methods" do
    describe "#subtotal" do
      it "calculates the subtotal based on item price before discounts are applied" do
        discount = create(:discount, threshold: 5, percentage: 10)
        item = create(:item, unit_price: 10)
        invoice_item = create(:invoice_item, quantity: 5, item: item, discount: discount)

        expect(invoice_item.subtotal).to eq(50)
      end
    end

    describe "#discount_amount" do
      it "calculates the discount" do
        discount = create(:discount, threshold: 5, percentage: 10)
        item = create(:item, unit_price: 10)
        invoice_item = create(:invoice_item, quantity: 5, item: item, discount: discount, unit_price: 9)

        expect(invoice_item.discount_amt).to eq(-5)
      end
    end

    describe "#total" do
      it "calculates the total amount due" do
        discount = create(:discount, threshold: 5, percentage: 10)
        item = create(:item, unit_price: 10)
        invoice_item = create(:invoice_item, quantity: 5, item: item, discount: discount, unit_price: 9)

        expect(invoice_item.total).to eq(45)
      end
    end

    describe "#discount_code" do
      
    end
  end
end
