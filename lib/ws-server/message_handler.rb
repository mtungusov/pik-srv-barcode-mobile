module WsServer; end

  require 'json-rpc-objects/request'

class WsServer::MessageHandler
  def self.handle(ws, data)
    $log.info "Object: #{parse(data)}"
  end

  def self.parse(data)
    [JsonRpcObjects::V20::Request.parse(data), nil]
  rescue Exception => e
    [nil, { error: e.message }]
  end
end