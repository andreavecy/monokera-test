require 'bunny'

class RabbitMQConnection
  def self.connect
    retries = 0
    begin
      connection = Bunny.new(hostname: 'rabbitmq')
      connection.start
      puts "RabbitMQ connected"
      connection
    rescue Bunny::TCPConnectionFailed => e
      retries += 1
      puts "RabbitMQ connection failed, retry ##{retries}: #{e.message}"
      sleep(2)
      retry if retries < 10
      raise "RabbitMQ is unreachable after #{retries} attempts"
    end
  end
end
