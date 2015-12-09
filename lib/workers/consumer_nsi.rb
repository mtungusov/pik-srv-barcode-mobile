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
    _clear_cache $cache
    loop do
      consumer.poll.each do |record|
        _to_cache $cache, record
        notify_ws_clients(record)
        # info "value: #{record.value}, offset: #{record.offset}, topic: #{record.topic}"
      end
      sleep 0.1
    end
  end

  def process_from_beginning
    _from_beginning
    process
  end

  def notify_ws_clients(record)
    info "New record in #{record.topic}"
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

  def _to_cache(cache, record)
    # todo
    # delete empty row from cahce
    #
    key = record.key
    data = _gen_data(record)
    cache.with do |con|
      if data.key? :value
        con.set "#{record.topic}:#{key}", data.to_json
      else
        con.del "#{record.topic}:#{key}"
      end
      con.zadd record.topic, record.offset, key
    end
  end

  def _clear_cache(cache)
    cache.with do |con|
      topics.each { |t| con.del t.topic }
    end
  end

  def _gen_data(record)
    begin
      _empty_data(record).merge({ value: JSON.parse(record.value) })
    rescue
      _empty_data(record)
    end
  end

  def _empty_data(record)
    {
        topic: record.topic,
        offset: record.offset,
        key: record.key
    }
  end
end