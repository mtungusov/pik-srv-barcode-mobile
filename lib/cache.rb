module Cache; end
require_relative 'cache/redis_connection'

module Cache
  module_function

  def pool(options={})
    @cache_pool ||= Cache::RedisConnection.create options
  end

  def shutdown
    @cache_pool.shutdown { |conn| conn.quit } if @cache_pool
  end
end
