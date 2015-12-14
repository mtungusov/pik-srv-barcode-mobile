require 'util'

module Commands
  module_function

  def ping(args)
    [:pong, nil]
  end

  def fetch_data(args)
    topic = args[:topic]
    offset = args[:offset].to_i
    offset = offset.zero? ? 0 : offset.pred
    return [nil, {code: 400, message: 'Bad request'}] unless topic

    data = $cache.with do |con|
      Util.get_keys_with_max_offsets(
          con.zrange(topic, offset, -1, with_scores: true)
      ).map { |k| JSON.parse con.get("#{topic}:#{k}") }
    end

    return [{data: data}, nil]
  rescue Exception => e
    [nil, {code: 500, message: e.message}]
  end
end