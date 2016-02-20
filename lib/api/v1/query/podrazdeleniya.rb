class API::V1::Query::Podrazdeleniya < Grape::API
  resource :podrazdeleniya do
    desc 'Получить Подразделения'
    params do
      requires :id, type: String, desc: 'Unique id for request (UUID)'
      requires :offset, type: Integer, desc: 'Offset from client'
    end

    get do
      {
        result: { offset: params[:offset]+1, data:[] },
        id: params[:id]
      }
    end
  end
end
