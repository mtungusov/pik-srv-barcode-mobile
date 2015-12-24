require 'util'

module Commands
  module_function

  def ping(args)
    [:pong, nil]
  end

  def fetch_data(args)
    topic = args[:topic]
    offset = args[:offset].to_i
    return [nil, {code: 400, message: 'Bad request'}] unless topic

    data = $cache.with do |con|
      Util.get_keys_with_max_offsets(
          con.zrangebyscore(topic, offset, "+inf", with_scores: true)
      ).map { |key, offset| _get_obj(con, topic, key, offset.to_i) }
    end

    return [{data: data}, nil]
  rescue Exception => e
    [nil, {code: 500, message: e.message}]
  end

  def _get_obj(cache_con, topic, key, offset)
    obj = cache_con.get("#{topic}:#{key}")
    if obj
      JSON.parse obj
    else
      _empty_obj(topic, key, offset)
    end
  end

  def _empty_obj(topic, key, offset)
    {
        type: topic,
        id: key,
        meta: {
            offset: offset
        }
    }
  end

end
