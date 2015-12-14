module JsonRpc
  class Request

    attr_reader :method, :params, :id

    def initialize(method, params={}, id = nil)
      @method = method.to_sym
      @params = params.is_a?(::Hash) ? hash_to_sym(params) : params
      @id = id
    end

    def to_json
      obj = to_h
      if JsonRpc::valid_request? obj
        obj.to_json
      else
        raise StandardError, "Invalid JsonRpc::Request"
      end
    end

    def to_h
      h = {
          jsonrpc: JSON_RPC_VERSION,
          method: method
      }
      h.merge!(params: params) if params && !params.empty?
      h.merge!(id: id) if id
      h
    end

    def hash_to_sym(data)
      data.keys.inject({}) do |acc, key|
        k = key.is_a?(::String) ? key.to_sym : key
        v = data[key].is_a?(::Hash) ? hash_to_sym(data[key]) : data[key]
        acc[k] = v
        acc
      end
    end

    def self.parse(data)
      request = JSON.parse data, symbolize_names: true
      raise 'Invalid JSONRPC data' unless JsonRpc.valid_request? request

      self.new(request[:method], request[:params], request[:id])
    end
  end
end