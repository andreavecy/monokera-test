require 'net/http'
require 'json'

class OrderClient
  ORDER_SERVICE_URL = ENV.fetch("ORDER_SERVICE_URL", "http://order_service:3000")

  def self.get_orders_count(customer_id)
    url = URI("#{ORDER_SERVICE_URL}/orders/count_by_customer/#{customer_id}")
    response = Net::HTTP.get_response(url)

    return 0 unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)["orders_count"]
  rescue StandardError => e
    puts "Error fetching orders count: #{e.message}"
    0
  end
end
