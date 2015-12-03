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
end
