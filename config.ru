#!/usr/bin/env jruby
# Run: bundle exec puma -e production -C config/puma.rb

$: << '.'
require 'lib/web_socket_app'

puts 'Rack start'
run WebSocketApp

trap('INT') { stop }
trap('TERM') { stop }

def stop
  puts 'Catch INT or TERM'
  sleep 5
  exit!
end
