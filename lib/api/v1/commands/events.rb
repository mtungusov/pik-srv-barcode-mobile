class API::V1::Commands::Events < Grape::API
  resource :events do
    desc 'Послать события ТСД в DB'
    params do
      requires :id, type: String, desc: 'Unique id for request (UUID)'
      requires :params, type: Hash do
        requires :data, type: Array, desc: 'events' do
          requires :event_key, type: String, desc: 'GUID события'
          requires :event_type, type: String, desc: 'Тип события'
          requires :event_val, type: Hash, desc: 'Значение события'
        end
      end
    end

    before do
      if $settings.debug
        puts "REQUEST: #{request.body.read.to_s}"
        request.body.rewind
      end
    end

    post do
      authenticate!
      r, err = Db.add_events declared(params).params[:data]
      result = { result: {processed: r}, id: params[:id] }
      result.merge!({errors: err}) unless err.empty?
      return result
    end
  end
end
