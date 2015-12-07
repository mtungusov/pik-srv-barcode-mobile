module Workers; end

class Workers::ConsumerNsi
  include Celluloid
  include Celluloid::Internals::Logger

  finalizer :shutdown

  attr_reader :consumer

  def initialize(options, topics)
    info "ConsumerNsi starting up..."
    @consumer = Kafka::Consumer.new options
    consumer.subscribe topics
  end

  def process
    loop do
      consumer.poll.each do |record|
        info "value: #{record.value}, offset: #{record.offset}, topic: #{record.topic}"
      end
      sleep 0.1
    end
  end

  def shutdown
    info "ConsumerNsi shutdown"
    sleep 1.0
    # consumer.close
  end
end