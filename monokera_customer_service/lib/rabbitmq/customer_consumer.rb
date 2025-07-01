require 'bunny'
require_relative '../../app/models/customer'

connection = Bunny.new(hostname: 'rabbitmq')
connection.start

channel = connection.create_channel
queue = channel.queue('', exclusive: true)
exchange = channel.fanout('customer_created', durable: true)
queue.bind(exchange)

puts ' [*] Waiting for customer created messages...'

queue.subscribe(block: true) do |_delivery_info, _properties, body|
  data = JSON.parse(body)
  puts " [x] Received #{data}"

  Customer.create(
    id: data['id'],
    name: data['name'],
    email: data['email'],
    phone: data['phone'],
    address: data['address']
  )
end
