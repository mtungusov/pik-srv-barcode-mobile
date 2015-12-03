require 'faye/websocket'
require 'rack'

WebSocketApp = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)


    ws.rack_response
  else
    [200, {'Content-Type' => 'text/plain'}, ['Websocket Server']]
  end
end

# Puma require the 'log' method for the server request logging
def WebSocketApp.log(message)
  $stdout.puts message
end
