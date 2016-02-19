class API::Ping < Grape::API
  resource :ping do
    get '/' do
      { result: 'pong' }
    end
  end
end
