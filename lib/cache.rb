require 'cache/redis_connection'

module Cache
  module_function

  def pool
    @cache_pool ||= Cache::RedisConnection.create
  end
end