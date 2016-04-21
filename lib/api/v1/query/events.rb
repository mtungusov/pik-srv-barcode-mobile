class API::V1::Query::Events < Grape::API
  resource :events do
    desc 'Получить события из DB'
    params do
      requires :device, type: String, desc: 'Device serial number'
      optional :offset, type: Integer, desc: 'Offset from client', default: 0
    end

    get do
      r, err = Db.get_events 'EventLog1S', params[:offset]
      result = {
          result: {data: r}
      }
      result.merge!({error: err}) if err
      return result
    end
  end
end
