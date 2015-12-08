module Workers; end

class Workers::ProducerNsi
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :producer

  def initialize(options)
    info "ProducerPandom starting up..."
    @producer = Kafka::Producer.new(options[:producer], options[:timeout])
  end

  def process_podr
    msg = Util::generate_random_podr
    key = msg[:guid]
    _send_message('1s-references-podrazdeleniya', key, msg)
  end

  def process_sotr
    msg = Util::generate_random_sotr
    key = msg[:guid]
    _send_message('1s-references-sotrudniki', key, msg)
  end

  def _send_message(topic, key, message)
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
