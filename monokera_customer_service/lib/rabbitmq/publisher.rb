require 'bunny'

class Publisher
  def initialize
    connection = Bunny.new(hostname: 'rabbitmq')
    connection.start
    @channel = connection.create_channel
    @exchange = @channel.fanout('customer_created')
  end

  def publish(message)
    @exchange.publish(message.to_json)
    puts " [x] Sent: #{message}"
  end
end
