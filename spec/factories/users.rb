FactoryBot.define do
  factory :user do
    username {Faker::Name.name.delete(' ').downcase}
    password {Faker::String.random(length: 8..16)}
  end
end
