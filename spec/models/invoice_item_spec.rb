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
    it "total_revenue" do
      discount = create(:discount, threshold: 5, percentage: 10)
      items = create_list(:item, 2, unit_price: 10)
      create(:invoice_item, quantity: 5, item: items[0], discount: discount, unit_price: 9)
      create(:invoice_item, quantity: 5, item: items[1], discount: discount, unit_price: 9)

      expect(InvoiceItem.total_revenue).to eq(90)
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
        merchant = create(:merchant)
        discount = create(:discount, threshold: 5, percentage: 10, merchant: merchant)
        item = create(:item, unit_price: 10, merchant: merchant)
        invoice_item = create(:invoice_item, quantity: 5, item: item, discount: discount, unit_price: 9)

        expect(invoice_item.discount_amt).to eq(-5)
      end
    end

    describe "#total" do
      it "calculates the total amount due" do
        merchant = create(:merchant)
        discount = create(:discount, threshold: 5, percentage: 10, merchant: merchant)
        item = create(:item, unit_price: 10, merchant: merchant)
        invoice_item = create(:invoice_item, quantity: 5, item: item, discount: discount, unit_price: 9)

        expect(invoice_item.total).to eq(45)
      end
    end
  end

  describe 'class methods' do
    describe "#discount_total" do
      it "calculates the discount amount for a group of invoice_items" do
        discount = create(:discount, threshold: 5, percentage: 10)
        items = create_list(:item, 2, unit_price: 10)
        create(:invoice_item, quantity: 5, item: items[0], discount: discount, unit_price: 9)
        create(:invoice_item, quantity: 5, item: items[1], discount: discount, unit_price: 9)

        expect(InvoiceItem.discount_total).to eq(-10)
      end
    end
  end

  it "finds bulk discounts" do
    merchant = create(:merchant)
    discount = create(:discount, merchant: merchant, threshold: 5, percentage: 10)
    item = create(:item, merchant: merchant, unit_price: 10)
    invoice = create(:invoice, merchant: merchant, status: 0)
    invoice_item = invoice.invoice_items.create(item_id: item.id, quantity: 5, status: 0)

    expect(invoice_item.unit_price).to eq(9)
  end
end
