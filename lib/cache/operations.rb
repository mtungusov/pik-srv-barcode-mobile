module Cache
  module_function

  def save_record(record)
    topic, offset, key, value = record.topic, record.offset, record.key, record.value
    Cache.pool.with do |conn|
      value == 'null' ? conn.del("#{topic}:#{key}") :  conn.set("#{topic}:#{key}", value)
      conn.zadd(topic, offset, key)
      conn.hmset('topic_offsets', topic, offset)
    end
  rescue Exception => e
    p "Error save record to cache: #{e.message}"
  end

  def check_for_update(params)
    topic, offset = params[:topic], params[:offset]
    topic ? _check_for_update_topic(topic, offset) : _check_for_update_all
  end

  private

  def _check_for_update_topic(topic, offset)
    db_offset = Cache.pool.with { |conn| conn.hget('topic_offsets', topic) }
    (db_offset.nil? or (offset.to_i == db_offset.to_i)) ? nil : { topic => db_offset.to_i }
  end

  def _check_for_update_all
    Cache.pool.with { |conn| conn.hgetall('topic_offsets') }
  end
end
