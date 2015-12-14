module JsonRpc
  class Response

    attr_reader :result, :error, :id

    def initialize(id, result: nil, error: nil)
      @result = result
      @error = error
      @id = id
    end

    def to_json
      obj = to_h
      if JsonRpc::valid_response? obj
        obj.to_json
      else
        raise StandardError, "Invalid JsonRpc::Response"
      end
    end

    def to_h
      h = {
          jsonrpc: JSON_RPC_VERSION,
          id: id
      }
      if error
        h.merge!(error: error)
      else
        h.merge!(result: result)
      end

      h
    end
  end
end