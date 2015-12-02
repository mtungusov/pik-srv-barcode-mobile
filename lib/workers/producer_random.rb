class Workers::ProducerRandom
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :producer

  def initialize
    info "ProducerPandom starting up..."
    @producer = Kafka::Producer.new(
        { 'bootstrap.servers'=>$config['connection']['kafka'] },
        $config['connection']['timeout_in_ms']
    )
  end

  def process
    msg = Util::generate_random_msg
    key = msg[:barcode]
    _send_message(key, msg)
  end

  def _send_message(key, message)
    r, e = producer.send_message($config['kafka']['topic'], key, message)
    error e[:error] if e
    info "producer sent: #{message}, offset: #{r.offset}" if r
  end

  def shutdown
    info "Shuting down begin..."
    sleep 2.0
    info "Shuting complete!"
  end
end
