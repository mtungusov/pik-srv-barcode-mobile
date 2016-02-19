require 'grape'
require 'json'

module API; end
require_relative 'api/v1'

module API
  class App < Grape::API
    prefix 'api'
    format :json

    get '/' do
      { result: 'Barcode-Mobile API Server' }
    end

    mount API::V1
  end
end
