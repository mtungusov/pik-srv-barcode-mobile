class Workers::Consumer
  include Celluloid


  def initialize(options, topics_as_str_arr)
    p "Consumer starting up..."
    @consumer = Kafka::Consumer.new options
    @topics = _gen_topics topics_as_str_arr
  end

  def process
    p 'Consumer process begin'
    _prepare
    _run_poll
  rescue org.apache.kafka.common.errors.WakeupException
    p "consumer wakeup"
  rescue Exception => e
    p e.message
  ensure
    @consumer.close
    p 'Consumer process end'
  end

  private

  def _prepare
    @consumer.assign @topics
    @topics.each { |t| @consumer.seek_to_beginning t }
  end

  def _run_poll
    loop do
      records = @consumer.poll(java.lang.Long::MAX_VALUE)
      records.forEach { |r| _process_record r }
    end
  end

  def _gen_topics(topics)
    topics.map { |t| @consumer.gen_topic_partition t }
  end

  def _process_record(record)
    p "key: #{record.key}, value: #{record.value}, offset: #{record.offset}, topic: #{record.topic}"
  end
end
