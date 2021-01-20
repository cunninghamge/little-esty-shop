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
      merchant = create(:merchant)
      discount = create(:discount, threshold: 5, percentage: 10, merchant: merchant)
      items = create_list(:item, 2, unit_price: 10, merchant: merchant)
      create(:invoice_item, quantity: 5, item: items[0])
      create(:invoice_item, quantity: 5, item: items[1])

      expect(InvoiceItem.revenue).to eq(90)
    end
  end

  describe "instance methods" do
    describe "#subtotal" do
      it "calculates the subtotal based on item price before discounts are applied" do
        merchant = create(:merchant)
        discount = create(:discount, threshold: 5, percentage: 10, merchant: merchant)
        item = create(:item, unit_price: 10, merchant: merchant)
        invoice_item = create(:invoice_item, quantity: 5, item: item)

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
        invoice_item = create(:invoice_item, quantity: 5, item: item)

        expect(invoice_item.total).to eq(45)
      end
    end
  end

  describe 'class methods' do
    describe "#discount_total" do
      it "calculates the discount amount for a group of invoice_items" do
        merchant = create(:merchant)
        discount = create(:discount, threshold: 5, percentage: 10, merchant: merchant)
        items = create_list(:item, 2, unit_price: 10, merchant: merchant)
        create(:invoice_item, quantity: 5, item: items[0])
        create(:invoice_item, quantity: 5, item: items[1])

        expect(InvoiceItem.discount_total).to eq(-10)
      end
    end
  end

  describe "bulk discounts" do
    let!(:merchant_1) {create(:merchant)}
    let!(:discount_1) {create(:discount, merchant: merchant_1, percentage: 20, threshold: 10)}
    let!(:discount_2) {create(:discount, merchant: merchant_1, percentage: 30, threshold: 16)}
    let!(:discount_3) {create(:discount, merchant: merchant_1, percentage: 15, threshold: 15)}
    let!(:invoice) {create(:invoice)}
    let!(:item_1) {create(:item, merchant: merchant_1, unit_price: 10)}
    let!(:item_2) {create(:item, merchant: merchant_1, unit_price: 10)}

    let!(:merchant_2) {create(:merchant)}
    let!(:item_3) {create(:item, merchant: merchant_2, unit_price: 10)}

    it "does not apply discounts if the order does not meet the threshold" do
      invoice_item_1 = invoice.invoice_items.create!(item: item_1, quantity: 5)
      invoice_item_2 = invoice.invoice_items.create!(item: item_2, quantity: 5)

      expect(invoice_item_1.discount).to eq(nil)
      expect(invoice_item_1.unit_price).to eq(10)
      expect(invoice_item_2.discount).to eq(nil)
      expect(invoice_item_2.unit_price).to eq(10)
    end

    it "can discount certain items but not all items in an order" do
      invoice_item_1 = invoice.invoice_items.create!(item: item_1, quantity: 10)
      invoice_item_2 = invoice.invoice_items.create!(item: item_2, quantity: 5)

      expect(invoice_item_1.discount).to eq(discount_1)
      expect(invoice_item_2.discount).to eq(nil)
    end

    it "can discount items on an order at different rates when appropriate" do
      invoice_item_1 = invoice.invoice_items.create!(item: item_1, quantity: 12)
      invoice_item_2 = invoice.invoice_items.create!(item: item_2, quantity: 16)

      expect(invoice_item_1.discount).to eq(discount_1)
      expect(invoice_item_1.unit_price).to eq(8)
      expect(invoice_item_2.discount).to eq(discount_2)
      expect(invoice_item_2.unit_price).to eq(7)
    end

    it "selects the better discount when multiple discounts are available" do
      invoice_item_1 = invoice.invoice_items.create!(item: item_1, quantity: 12)
      invoice_item_2 = invoice.invoice_items.create!(item: item_2, quantity: 15)

      expect(invoice_item_1.discount).to eq(discount_1)
      expect(invoice_item_2.discount).to eq(discount_1)
    end

    it "does not apply discounts to other merchants' items" do
      invoice_item_1 = invoice.invoice_items.create!(item: item_1, quantity: 12)
      invoice_item_2 = invoice.invoice_items.create!(item: item_2, quantity: 16)
      invoice_item_3 = invoice.invoice_items.create!(item: item_3, quantity: 16)

      expect(invoice_item_1.discount).to eq(discount_1)
      expect(invoice_item_1.unit_price).to eq(8)
      expect(invoice_item_2.discount).to eq(discount_2)
      expect(invoice_item_2.unit_price).to eq(7)
      expect(invoice_item_3.discount).to eq(nil)
      expect(invoice_item_3.unit_price).to eq(10)
    end
  end
end
