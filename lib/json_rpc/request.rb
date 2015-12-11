module JsonRpc
  class Request

    attr_reader :method, :params, :id

    def initialize(method, params={}, id = nil)
      @method = method
      @params = params
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

    def parse(date)
      raise NotImplemented
    end
  end
end