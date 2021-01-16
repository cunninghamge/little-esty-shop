FactoryBot.define do
  factory :discount do
    association :merchant
    percentage {rand(5..40)}
    threshold {rand(2..20)}

    factory :discount_1 do
      percentage {20}
      threshold {10}
    end
  end
end
