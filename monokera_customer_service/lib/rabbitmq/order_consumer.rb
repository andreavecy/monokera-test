require_relative '../../config/environment'
require 'bunny'
require 'json'

connection = Bunny.new(hostname: 'rabbitmq')
connection.start

channel = connection.create_channel
queue = channel.queue('order_created', durable: true)

puts "👂 [*] Waiting for messages in order_created. To exit press CTRL+C"

queue.subscribe(block: true) do |_delivery_info, _properties, body|
  puts "📥 Received order: #{body}"
  begin
    data = JSON.parse(body)

    puts "✅ Processing order ID: #{data['id']} for customer ID: #{data['customer_id']} with total #{data['total']}"

  rescue => e
    puts "❌ Error processing order: #{e.message}"
    puts e.backtrace
  end
end
