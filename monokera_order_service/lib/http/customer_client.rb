require 'net/http'
require 'json'
require 'uri'

class CustomerClient
  BASE_URL = ENV.fetch('CUSTOMER_SERVICE_URL', 'http://customer_service:3000')

  def self.find_customer(customer_id)
    url = URI.parse("#{BASE_URL}/customers/#{customer_id}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error("Error fetching customer: #{response.code} - #{response.message}")
      nil
    end
  rescue => e
    Rails.logger.error("HTTP request failed: #{e.message}")
    nil
  end
end
