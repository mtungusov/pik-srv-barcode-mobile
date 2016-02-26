module Cache
  module_function

  def save_record(record)
    topic, offset, key, value = record.topic, record.offset, record.key, record.value
    Cache.pool.with do |conn|
      value == 'null' ? conn.del("#{topic}:#{key}") :  conn.set("#{topic}:#{key}", value)
      conn.zadd(topic, offset, key)
      conn.hmset("topic_offsets", topic, offset)
    end
  rescue Exception => e
    p "Error save record to cache: #{e.message}"
  end
end
