require_relative 'ping'

class API::V1 < Grape::API; end

Dir["#{File.dirname(File.expand_path(__FILE__))}/v1/*.rb"].each do |f|
  require f
end

# Imported from commands.rb
# require_relative 'v1/commands/helpers'

class API::V1 < Grape::API
  version 'v1', using: :path
  helpers QueryHelpers
  mount API::Ping
  mount API::V1::Query
  mount API::V1::Commands
end
