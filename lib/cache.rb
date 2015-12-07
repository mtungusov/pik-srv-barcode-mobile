require 'cache/redis_connection'

module Cache
  module_function

  def pool(options={})
    @cache_pool ||= Cache::RedisConnection.create options
  end
end