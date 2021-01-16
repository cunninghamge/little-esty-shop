class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :threshold, :percentage

  delegate :discounts_index, to: :merchant

  def discount_code
    "B#{merchant.id}#{discounts_index(id)}#{updated_at.strftime("%m%y")}"
  end

  def self.discounts_index(id)
    where("id <= ?", id).count
  end
end
