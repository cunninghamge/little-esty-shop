FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    association :item
    association :invoice
    quantity { Faker::Number.between(from: 1, to: 10) }

    trait :sequenced do
      sequence :quantity
    end
  end
end
