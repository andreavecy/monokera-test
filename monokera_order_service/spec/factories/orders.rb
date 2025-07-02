
FactoryBot.define do
  factory :order do
    customer_id { 1 }
    status { "pending" }
    total { 100.5 }

    after(:build) do |order|
      order.order_items << build(:order_item, order: order)
    end
  end

  factory :order_item do
    product_name { "Sample Item" }
    quantity { 2 }
    price { 50.25 }
    order
  end

end
