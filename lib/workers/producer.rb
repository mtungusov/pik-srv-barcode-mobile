require 'json'

class Workers::Producer
  include Celluloid

  def initialize(producer_options, timeout)
    p "Producer starting up..."
    @producer = Kafka::Producer.new(producer_options, timeout)
  end

  def send_message(topic, key, message=nil)
    data = message.nil? ? nil : message.to_json
    r, e = @producer.send_message(topic, key, data)
    puts "Error: #{e.message}" if e
    puts "Debug: producer sent: #{message}, offset: #{r.offset}" if r
    [r, e]
  end

  def close
    @producer.close
  end
end
