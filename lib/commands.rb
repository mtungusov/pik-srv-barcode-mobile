module Commands
  module_function

  def ping(args)
    [:pong, nil]
  end

  def fetch_data(args)
    [nil, {code: 1, message: 'Not implemented'}]
  end
end