class API::V1::Query < Grape::API; end

Dir["#{File.dirname(File.expand_path(__FILE__))}/query/*.rb"].each do |f|
  require f
end

class API::V1::Query < Grape::API
  resource :query do
    get '/' do
      { result: queries }
    end

    mount API::V1::Query::Podrazdeleniya
    mount API::V1::Query::QueryForUpdates
  end
end
