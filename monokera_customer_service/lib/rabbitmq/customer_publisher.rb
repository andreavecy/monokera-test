require_relative 'publisher'
module Rabbitmq

  class CustomerPublisher
    EXCHANGE_NAME = 'customer_created'

    def self.publish(customer)
      Publisher.publish(EXCHANGE_NAME,
        {
          id: customer.id,
          name: customer.name,
          email: customer.email,
          phone: customer.phone,
          address: customer.address
        }
      )
    end
  end
end
