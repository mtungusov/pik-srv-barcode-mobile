class API::V1::Query::EventsRest < Grape::API
  resource :rest do
    desc 'Получить количество оставшихся событий в DB для устройства'
    params do
      optional :offset, type: Integer, desc: 'Offset from client', default: 0
    end

    get do
      authenticate!
      r, err = Db.get_events_rest current_device, params[:offset]
      result = {
          result: {rest: r, device_guid: current_device}
      }
      result.merge!({error: err}) if err
      return result
    end
  end
end
