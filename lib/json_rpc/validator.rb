module JsonRpc
  module_function

  def valid_response?(data)
    return false unless data.is_a?(::Hash)
    return false unless data[:jsonrpc] == JSON_RPC_VERSION
    return false unless data[:id].is_a?(::String) || data[:id].is_a?(::Fixnum)
    return false if data[:result] && data[:error]
    if data[:error]
      return false unless valid_error? data[:error]
    end

    true
  rescue
    false
  end

  def valid_request?(data)
    return false unless data.is_a?(::Hash)
    return false unless data[:jsonrpc] == JSON_RPC_VERSION
    return false unless data[:method].is_a?(::String) || data[:method].is_a?(::Symbol)
    if data[:id]
      return false unless data[:id].is_a?(::String) || data[:id].is_a?(::Fixnum)
    end

    if data[:params]
      return false unless data[:params].is_a?(::Hash) || data[:params].is_a?(::Array)
    end

    true
  rescue
    false
  end

  def valid_error?(data)
    return false unless data.is_a?(::Hash)
    return false unless data[:code].is_a?(::Fixnum)
    return false unless data[:message].is_a?(::String)

    true
  rescue
    false
  end
end