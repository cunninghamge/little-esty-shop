FactoryBot.define do
  factory :merchant do
    name {Faker::App.unique.name}
  end
end
