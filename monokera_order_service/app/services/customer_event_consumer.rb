require 'bunny'

class CustomerEventConsumer
  def self.start
    connection = Bunny.new(hostname: ENV.fetch('RABBITMQ_HOST', 'rabbitmq'))
    connection.start

    channel = connection.create_channel
    queue = channel.queue('customer.created', durable: true)

    puts ' [*] Waiting for messages in customer.created. To exit press CTRL+C'

    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      payload = JSON.parse(body)
      puts " [x] Received #{payload}"
    end
  end
end
