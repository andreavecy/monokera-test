require 'bunny'
require 'json'

module Rabbitmq
  class Publisher
    def self.publish(queue_name, message)
      retries ||= 0

      connection = Bunny.new(hostname: 'rabbitmq')
      connection.start

      channel = connection.create_channel
      queue = channel.queue(queue_name, durable: true)

      channel.default_exchange.publish(
        message.to_json,
        routing_key: queue.name,
        persistent: true
      )

      puts "Message sent to #{queue_name}: #{message}"
      connection.close

    rescue Bunny::TCPConnectionFailed => e
      puts "RabbitMQ connection failed: #{e.message}"
      retries += 1
      sleep 2
      retry if retries < 5
    rescue => e
      puts "Error publishing to RabbitMQ: #{e.message}"
      puts e.backtrace
    end
  end
end
