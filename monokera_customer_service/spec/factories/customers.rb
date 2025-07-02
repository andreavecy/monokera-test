FactoryBot.define do
  factory :customer do
    name { "Test Name" }
    email { Faker::Internet.email }
    phone { "1234567890" }
    address { "Test Address" }
  end
end
