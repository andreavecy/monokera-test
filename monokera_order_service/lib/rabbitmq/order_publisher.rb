require_relative 'publisher'
module Rabbitmq
  class OrderPublisher
    EXCHANGE_NAME = 'order_created'

    def self.publish(order)
      Publisher.publish(EXCHANGE_NAME,
        {
          id: order.id,
          customer_id: order.customer_id,
          status: order.status,
          total: order.total,
          items: order.order_items.map do |item|
            {
              id: item.id,
              product_name: item.product_name,
              quantity: item.quantity,
              price: item.price
            }
          end
        }
      )
    end
  end
end