require_relative 'events/events_rest'

class API::V1::Query::Events < Grape::API
  resource :events do
    desc 'Получить события из DB'
    params do
      # requires :device, type: String, desc: 'Device serial number'
      optional :offset, type: Integer, desc: 'Offset from client', default: 0
    end

    get do
      authenticate!
      r, err = Db.get_events 'EventLog1S', current_device, params[:offset]
      result = {
          result: {data: r}
      }
      result.merge!({error: err}) if err
      return result
    end

    mount API::V1::Query::EventsRest
  end
end
