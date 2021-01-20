FactoryBot.define do
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address { Faker::Address.full_address}

    trait :with_transactions do
      transient { merchant { create(:merchant)} }
      transient { successful {1}}
      transient { failed {1}}

      after(:create) do |customer, transient|
        transient.successful.times do
          item = create(:item, merchant: transient.merchant)
          create(:invoice, :with_successful_transaction, item: item, customer: customer)
        end
        transient.failed.times do
          item = create(:item, merchant: transient.merchant)
          create(:invoice, :with_failed_transaction, item: item, customer: customer)
        end
      end
    end
  end
end
