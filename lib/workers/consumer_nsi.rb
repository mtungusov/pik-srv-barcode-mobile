module Workers; end

class Workers::ConsumerNsi
  include Celluloid
  include Celluloid::Internals::Logger

  finalizer :shutdown

  attr_reader :consumer, :topics

  def initialize(options, topics_as_str_arr)
    info "ConsumerNsi starting up..."
    @consumer = Kafka::Consumer.new options
    @topics = _gen_topics topics_as_str_arr
    _assign_topics
  end

  def process
    loop do
      consumer.poll.each do |record|
        info "value: #{record.value}, offset: #{record.offset}, topic: #{record.topic}"
      end
      sleep 0.1
    end
  end

  def process_from_beginning
    _from_beginning
    process
  end

  def shutdown
    info "ConsumerNsi shutdown"
    sleep 1.0
    # consumer.close
  end

  def _gen_topics(m_topics)
    m_topics.map { |t| consumer.gen_topic_partition t }
  end

  def _assign_topics
    consumer.assign topics
    info "Consumer topics: #{consumer.consumer.assignment}"
  end

  def _from_beginning
    topics.each { |t| consumer.seek_to_beginning t }
  end
end