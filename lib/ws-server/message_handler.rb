require 'json_rpc'

require 'commands'

module WsServer; end

module WsServer::MessageHandler
  KNOW_COMMANDS = %i[
    ping
    fetch_data
  ]

  module_function

  def handle(ws, data)
    result, err, request_id = nil, nil, nil
    obj, err = _parse data
    $log.info "After _parse #{[obj, err]}"
    result = if err
               req_id = obj ? obj.id : nil
               JsonRpc::Response.new(req_id, error: err)
             else
               _process obj
             end

    _response(ws, result) if result
  end

  def _parse(data)
    obj = JsonRpc::Request.parse(data)
    result, err = _validate obj
    [result, err]
  rescue Exception => e
    [nil, {error: e.message}]
  end

  def _validate(jsonrpc_obj)
    err ||= {code: -32601, message: "Method not found"} unless KNOW_COMMANDS.include? jsonrpc_obj.method
    [jsonrpc_obj, err]
  end

  def _process(jsonrpc_obj)
    result, err = Commands.method(jsonrpc_obj.method).call(jsonrpc_obj.params)
    JsonRpc::Response.new(jsonrpc_obj.id, result: result, error: err)
  end

  def _response(websocket, response)
    websocket.send response.to_json
  rescue Exception => e
    $log.info "Error MessageHandler _response: #{e.message}"
  end
end