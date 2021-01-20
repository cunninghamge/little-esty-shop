FactoryBot.define do
  factory :invoice, class: Invoice do
    association :customer

    trait :with_successful_transaction do
      transient { item {create(:item)}}

      after(:create) do |invoice, transient|
        create(:invoice_item, item: transient.item, invoice: invoice)
        create(:transaction, invoice: invoice, result: 0)
      end
    end

    trait :with_failed_transaction do
      transient { item {create(:item)}}

      after(:create) do |invoice, transient|
        create(:invoice_item, item: transient.item, invoice: invoice)
        create(:transaction, invoice: invoice, result: 1)
      end
    end

    trait :sequenced do
      sequence :created_at do |n|
        n.days
      end
    end
  end
end
