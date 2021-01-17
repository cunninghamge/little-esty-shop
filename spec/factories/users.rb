FactoryBot.define do
  factory :user do
    username {Faker::Name.name.delete(' ').downcase}
    username {Faker::String.random(length: 8..16)}
  end
end
