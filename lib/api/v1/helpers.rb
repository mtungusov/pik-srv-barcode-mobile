module AuthHelpers
  API_AUTH_HEADER = /^DeviceGUID (\S*)$/.freeze
  def current_device
    @current_device = if headers['Authorization'] =~ API_AUTH_HEADER and !$1.empty?
      $1
    end
  end

  def authenticate!
    error!('401 Unauthorized', 401) unless current_device
  end
end
