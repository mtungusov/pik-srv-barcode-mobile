require 'connection_pool'
require 'redis'

module Cache; end

class Cache::RedisConnection
  KNOWN_OPTIONS = [:path, :url, :host, :port, :db]

  class << self
    def create(options={})
      pool_timeout = options[:pool_timeout] || 1
      pool_size = options[:pool_size] || 5

      ConnectionPool.new(timeout: pool_timeout, size: pool_size) do
        _build_client(options)
      end
    end

    def _build_client(options)
      namespace = options[:namespace]

      client = Redis.new _client_opts(options)
      
      if namespace
        require 'redis-namespace'
        Redis::Namespace.new(namespace, redis: client)
      else
        client
      end
    end

    def _client_opts(options)
      opts = options.dup

      (opts.keys - KNOWN_OPTIONS).map { |k| opts.delete k }

      if opts.key? :path
        [:url, :host, :port, :db].map { |k| opts.delete k }
      elsif opts.key? url
        [:host, :port, :db].map { |k| opts.delete k }
      end

      opts
    end
  end
end