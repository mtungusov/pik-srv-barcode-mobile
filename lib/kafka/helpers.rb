module Kafka::Helpers
  module_function

  def validated_options(options, required_opts, known_opts)
    err = []
    err << "Empty options" if options.empty?
    missing = required_opts.reject { |o| options[o] }
    err << "Missing required: #{missing.join(', ')}" if missing.any?
    unknown = options.keys - known_opts
    err << "Unknown: #{unknown.join(', ')}" if unknown.any?
    fail StandardError.new "Errors: #{ err.join('; ') }" if err.any?
    options
  end

  def create_config(options)
    props = java.util.Properties.new
    options.each { |k, v| props.put(k, v) }
    props
  end

end
