# spec/factories/customers.rb
FactoryBot.define do
  factory :customer do
    customer_name { "Carlos Segura" }
    address { "Calle 123" }
    orders_count { 0 }
  end
end
