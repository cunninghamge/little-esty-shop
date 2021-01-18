require 'rails_helper'

RSpec.describe Cart do
  subject {Cart.new({'1'=> 2, '2'=>3})}
  describe "#items_count" do
    it "can calculate the number of items it holds" do
      expect(subject.items_count).to eq(2)
    end
  end

  describe "#add_item" do
    it "adds items to the cart" do
      subject.add_item(1, 1)

      expect(subject.contents).to eq({'1'=> 3, '2'=>3})
    end

    it "can add an item if it hasn't been added yet" do
      subject.add_item(3, 1)

      expect(subject.contents).to eq({'1'=> 2, '2'=>3, '3'=> 1})
    end

    it "allows users to select a quantity" do
      subject.add_item(3, 4)

      expect(subject.contents).to eq({'1'=> 2, '2'=>3, '3'=> 4})
    end
  end

  describe "#count_of" do
    it "returns the quantity of the given item in the cart" do
      expect(subject.count_of(1)).to eq(2)
    end

    it "returns 0 if that item has not been added" do
      expect(subject.count_of(5)).to eq(0)
    end
  end
end
