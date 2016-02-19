class API::V1::Commands::DeletePodrazdeleniya < Grape::API
  resource :delete_podrazdeleniya do
    desc 'Удалить Подразделения'
    params do
      requires :id, type: String, desc: 'Unique id for request (UUID)'
      requires :params, type: Hash do
        requires :data, type: Array, desc: 'rows' do
          requires :guid, type: String, desc: 'GUID подразделения'
        end
      end
    end

    post do
      topic = '1s-references-podrazdeleniya'
      data = declared(params).params[:data]
      result = data.reduce({}) do |acc, d|
        r, e = send_to_kafka(topic, d[:guid])
        e.nil? ? acc[:offset] = r.offset : acc[:errors] << e
        acc
      end

      { result: result, id: params[:id] }
    end
  end
end
