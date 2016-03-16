class API::V1::Commands::UpdateBarcodesOtk < Grape::API
  resource :update_barcodes_otk do
    desc 'Обновить штрихкоды из ТСД Мастера ОТК'
    params do
      requires :id, type: String, desc: 'Unique id for request (UUID)'
      requires :params, type: Hash do
        requires :data, type: Array, desc: 'rows' do
          requires :guid, type: String, desc: 'Штрихкод на этикетке'
          requires :nomenclature, type: String, desc: 'Номенклатура изделия'
          requires :division_guid, type: String, desc: 'Подразделение'
          requires :line_guid, type: String, desc: 'Производственная линия'
          requires :status, type: String, desc: 'Новый или Брак'
          requires :crew_guid, type: String, desc: 'Выпускающая бригада'
          requires :change_at, type: Integer, desc: 'Время в сек. (Unixtime)'
          requires :user_guid, type: String, desc: 'Пользователь ОТК'
        end
      end
    end

    post do
      result = Workers.update_barcode_otk declared(params).params[:data]
      { result: result, id: params[:id] }
    end
  end
end
