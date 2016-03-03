require 'redis'
require 'connection_pool'

class Cache::RedisConnection
  class << self
    def create(options={})
      pool_timeout = options[:pool_timeout] || 1
      pool_size = options[:pool_size] || 5

      ConnectionPool.new(timeout: pool_timeout, size: pool_size) {_build_client(options) }
    end

    def _build_client(options)
      fail StandardError.new "Errors: missing required :url" unless options.key? :url
      Redis.new({ url: options[:url] })
    end

  end
end
