module Workers; end

class Workers::ConsumerTest
  include Celluloid
  include Celluloid::Internals::Logger

  finalizer :shutdown

  attr_reader :consumer

  def initialize(options, topic)
    info "ConsumerTest starting up..."
    @consumer = Kafka::Consumer.new options
    consumer.subscribe [topic]
  end

  def process
    loop do
      consumer.poll.each do |record|
        info "value: #{record.value}, offset: #{record.offset}"
      end
      sleep 0.1
    end
  end

  def shutdown
    # consumer.close
  end
end