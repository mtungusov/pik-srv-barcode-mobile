module Workers; end

class Workers::ConsumerTest
  include Celluloid
  include Celluloid::Internals::Logger

  finalizer :shutdown

  attr_reader :consumer

  def initialize
    info "ConsumerTest starting up..."
    @consumer = Kafka::Consumer.new (
      {
        'bootstrap.servers'=>'kafka.dev:9092',
        'group.id'=>'test-ruby-consumer'
      }
    )
    consumer.subscribe [$config['kafka']['topic']]
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