module Workers
  module_function

  def update_to(topic, key_sym, data_array, flag=:update)
    result = data_array.reduce({offset: -1, processed: 0, errors: []}) do |acc, d|
      r, e = case flag
               when :update
                 Celluloid::Actor[:kafka_producer].send_message(topic, d[key_sym], d)
               when :delete
                 Celluloid::Actor[:kafka_producer].send_message(topic, d[key_sym])
             end
      if e.nil?
        acc[:offset] = r.offset
        acc[:processed] += 1
      else
        acc[:errors] << e.message
      end
      acc
    end

    result
  end

  def update_barcode_otk(data_array)
    result = data_array.reduce({offset: -1, processed: 0, errors: []}) do |acc, d|
      r, e = Celluloid::Actor[:kafka_producer].send_message('barcode-production-out', d[:guid], d)
      if e.nil?
        # Удалить обработанный штрихкод из EventLog-а
        _, e_del = Celluloid::Actor[:kafka_producer].send_message('barcode-production-in', d[:guid])
        if e_del.nil?
          acc[:offset] = r.offset
          acc[:processed] += 1
        else
          acc[:errors] << e_del.message
        end
      else
        acc[:errors] << e.message
      end
      acc
    end

    result
  end

end
