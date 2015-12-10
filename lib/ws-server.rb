require 'eventmachine'
require 'websocket-eventmachine-server'

EM.run do
  $log.info 'EM start'
  trap('INT')  { stop }
  trap('TERM') { stop }

  WebSocket::EventMachine::Server.start(
      host: $config['connection']['websocket']['host'],
      port: $config['connection']['websocket']['port']
  ) do |ws|
    ws.onopen do
      device_id = ws.instance_variable_get('@handshake').path.match(/^\/(\w+)/)[1]
      if device_id != '111'
        ws.send Util::gen_ws_error_msg("client not allowed. closing")
        ws.close
      end
    end

    ws.onmessage do |msg, type|
      $log.info "Received message: #{msg}, type: #{type}"
    end

    ws.onclose do
      $log.info "Client disconnected"
    end
  end

  $log.info 'WS start'

  def stop
    $log.info 'EM stop'
    EM.stop
  end
end
