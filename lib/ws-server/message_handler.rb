require 'json-rpc-objects/request'
require 'json-rpc-objects/response'

require 'commands'

module WsServer; end

module WsServer::MessageHandler
  KNOW_COMMANDS = %i[
    ping
    fetchData
  ]

  module_function

  def handle(ws, data)
    result, err, request_id = nil, nil, nil
    $log.info "Before _parse"
    obj, err = _parse data
    $log.info "After _parse #{[obj, err]}"
    # result, err, request_id = _process obj unless err
    # $log.info "After _process #{[result, err, request_id]}"
    # _response(ws, result, err, request_id)
  end

  def _parse(data)
    $log.info "Before jsonrpc parse"
    obj = JsonRpcObjects::V20::Request.parse(data)
    $log.info "Before _validate"
    result, err = _validate obj
    $log.info "After _validate: #{}"
    [result, err]
  rescue Exception => e
    $log.info "_parse exception"
    [nil, {error: e.message}]
  end

  def _validate(jsonrpc_obj)
    err ||= {code: -32601, message: "Method not found"} unless KNOW_COMMANDS.include? jsonrpc_obj.method
    return [nil, err] if err
    [jsonrpc_obj, nil]
  end

  def _process(jsonrpc_obj)
    $log.info "Process: #{jsonrpc_obj}"
    result, err = Commands.method(jsonrpc_obj.method).call(jsonrpc_obj.params)

    [result, err, jsonrpc_obj.id]
  end

  def _response(websocket, result, error, request_id)
    obj = JsonRpcObjects::V20::Response.create(result, error, id: request_id)
    websocket.send obj.to_json
  rescue Exception => e
    $log.error "Error MessageHandler _response: #{e.message}"
  end
end