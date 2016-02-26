class API::V1::Query::QueryForUpdates < Grape::API
  resource :check_for_updates do
    desc 'Проверить обновления в базе'
    params do
      requires :id, type: String, desc: 'Unique id for request (UUID)'
      optional :topic, type: String, desc: 'Topic for check'
      optional :offset, type: Integer, desc: 'Offset from client'
    end

    get do
      result = Cache.check_for_update declared(params, include_missing: true)
      {
          result: result,
          id: params[:id]
      }
    end
  end
end
