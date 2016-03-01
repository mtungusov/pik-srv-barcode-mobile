require 'json'

module Cache
  module_function

  def save_record(record)
    topic, offset, key, value = record.topic, record.offset, record.key, record.value
    Cache.pool.with do |conn|
      (value.nil? or value == 'null') ? conn.del("#{topic}:#{key}") : conn.set("#{topic}:#{key}", value)
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

  def get_updates(params)
    topic, offset = params[:topic], params[:offset]
    db_offset = _get_offset(topic)
    return nil unless db_offset
    data = _get_updates(topic, offset.next)
    return nil if data.nil? or data.empty?
    { topic: topic, offset: db_offset, data: data }
  end

  def _get_offset(topic)
    Cache.pool.with { |conn| conn.hget('topic_offsets', topic) }
  end

  def _check_for_update_topic(topic, offset)
    db_offset = _get_offset(topic)
    (db_offset.nil? or (offset.to_i == db_offset.to_i)) ? nil : { topic => db_offset.to_i }
  end

  def _check_for_update_all
    Cache.pool.with { |conn| conn.hgetall('topic_offsets') }
  end

  def _get_updates(topic, offset)
    Cache.pool.with { |conn|
      conn.zrangebyscore(topic, offset, "+inf")
    }.map { |key| _get_record(topic, key) }
  end

  def _get_record(topic, key)
    record = Cache.pool.with { |conn| conn.get("#{topic}:#{key}") }
    (record.nil? or record.empty?) ? { guid: key } : JSON.parse(record)
  rescue Exception => e
    p "Error get_record Json.parse: #{e.message}"
    nil
  end
end
