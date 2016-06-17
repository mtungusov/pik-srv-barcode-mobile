class API::V1::Query::SrvEvents < Grape::API
  resource :srv_events do
    desc 'Получить события из сервисного лога'
    params do
      optional :offset, type: Integer, desc: 'Offset from client', default: 0
    end

    get do
      authenticate!
      r, err = Db.get_srv_events current_device, params[:offset]
      result = {
          result: {data: r}
      }
      result.merge!({error: err}) if err
      return result
    end
  end
end
