module Util
  module_function

  def generate_random_msg
    n = ('А'..'Я').to_a
    s = ["Новый", "Новый", "Новый", "Новый", "Новый", "Брак"]
    {
      barcode: "000#{(1..9).map {rand 9}.join}",
      nomenclature: "#{(1..4).map { n[rand(n.length)] }.join}-#{(1..3).map {rand 9}.join}",
      status: "#{s[rand(s.length)]}",
      change_at: Time.now.to_i
    }
  end

  def gen_ws_error_msg(text)
    {
        type: 'error',
        msg: text
    }.to_json
  end

  def generate_random_podr
    n = (1..3).map{rand 9}.join
    {
        guid: "ou-#{n}",
        name: "Склад-#{n}-#{rand 9}"
    }
  end

  def generate_random_sotr
    n = (1..3).map{rand 9}.join
    ln = %w[Иванов Петров Сидоров Васечкин]
    fn = %w[Александр Иван Петр Сидор Василий]
    {
        guid: "sotr-#{n}",
        fullname: "#{ln[rand(ln.length)]} #{fn[rand(fn.length)]}",
        ou: "Склад-#{n}",
        barcode: "200#{(1..9).map {rand 9}.join}"
    }
  end

  def generate_random_uuid
    ["%02x"*4, "%02x"*2, "%02x"*2, "%02x"*2, "%02x"*6].join("-") % (1..16).map {|x| rand(0xff) }
  end

  def get_keys_with_max_offsets(array_of_keys)
    # [[key, offset],...]
    # Return array of keys with max offset sorted by offset
    array_of_keys.inject({}) { |acc, e|
      acc[e[0]]=e[1] if (!acc[e[0]] || acc[e[0]] < e[1])
      acc
    }.sort_by { |e| e[1] }.inject([]) { |acc, e| acc << e[0] }
  end
end
