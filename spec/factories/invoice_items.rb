FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    association :item
    association :invoice
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.between(from: 50, to: 100000) }

    trait :sequenced do
      sequence :quantity
    end
  end
end
