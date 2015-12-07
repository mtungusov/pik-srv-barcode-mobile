module Workers; end

class Workers::ProducerRandom
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :producer, :topic

  def initialize(options, default_topic)
    info "ProducerPandom starting up..."
    @producer = Kafka::Producer.new(options[:producer], options[:timeout])
    @topic = default_topic
  end

  def process
    msg = Util::generate_random_msg
    key = msg[:barcode]
    _send_message(key, msg)
  end

  def _send_message(key, message)
    r, e = producer.send_message(topic, key, message)
    error e[:error] if e
    info "producer sent: #{message}, offset: #{r.offset}" if r
  end

  def shutdown
    info "Shuting down begin..."
    sleep 2.0
    info "Shuting complete!"
  end
end
