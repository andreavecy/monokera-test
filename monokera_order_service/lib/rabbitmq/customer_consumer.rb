require_relative '../../config/environment'

require 'bunny'
require 'json'

connection = Bunny.new(hostname: 'rabbitmq')
connection.start

channel = connection.create_channel
queue = channel.queue('customer_created', durable: true)

puts "👂 [*] Waiting for messages in customer_created. To exit press CTRL+C"

queue.subscribe(block: true) do |_delivery_info, _properties, body|
  puts "📥 Received customer: #{body}"
  begin
    data = JSON.parse(body)

    Customer.create!(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address']
    )

    puts "✅ Customer saved: #{data['name']}"
  rescue => e
    puts "❌ Error saving customer: #{e.message}"
    puts e.backtrace
  end
end
