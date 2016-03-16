require 'grape'
require 'json'

module API; end
require_relative 'api/v1'

module API
  class MyLogger
    def debug(message)
      puts "DEBUG: #{message}" if $settings.debug
    end
  end
  
  class App < Grape::API
    prefix 'api'
    format :json

    logger API::MyLogger.new
    helpers do
      def logger
        App.logger
      end
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      e_msg = e.full_messages
      puts "ValidationErrors: #{e_msg}" if $settings.debug
      error!({ errors: e_msg }, 400)
    end

    get '/' do
      { result: 'Barcode-Mobile API Server' }
    end

    mount API::V1
  end
end
