module Consumer; end

class Consumer::KafkaConsumer
  java_import org.apache.kafka.clients.producer.ProducerRecord
  java_import java.util.concurrent.TimeUnit

  REQUIRED_OPTIONS = %w[
  ]

  KNOWN_OPTIONS = %w[
  ]

  attr_reader :options

  def initialize(consumer_options)
    @options = consumer_options.dup
    @options['???'] = $config['connection']['???']

    _validate_options
  end

  def _validate_options
    err = []
    err << "Empty options" if options.empty?
    missing = REQUIRED_OPTIONS.reject { |o| options[o] }
    err << "Missing required: #{missing.join(', ')}" if missing.any?
    unknown = options.keys - KNOWN_OPTIONS
    err << "Unknown: #{unknown.join(', ')}" if unknown.any?
    fail StandardError.new "Errors: #{ err.join('; ') }" if err.any?
  end

  def _create_config
    properties = java.util.Properties.new
    options.each { |k, v| properties.put(k, v) }
    properties
  end
end