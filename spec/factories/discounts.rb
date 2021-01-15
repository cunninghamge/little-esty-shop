FactoryBot.define do
  factory :discount do
    association :merchant
    percentage {rand(5..40)}
    threshold {rand(2..20)}
  end
end
