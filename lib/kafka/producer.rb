require 'kafka'

class Kafka::Producer
  java_import org.apache.kafka.clients.producer.ProducerRecord
  java_import java.util.concurrent.TimeUnit

  KAFKA_PRODUCER = Java::org.apache.kafka.clients.producer.KafkaProducer

  REQUIRED_OPTIONS = %w[
    bootstrap.servers
    key.serializer
  ]

  KNOWN_OPTIONS = %w[
    acks
    bootstrap.servers
    compression.type
    key.serializer
    retries
    linger.ms
    value.serializer
    serializer.class
  ]

  attr_reader :options, :producer, :send_method, :send_timeout

  def initialize(producer_options={}, send_timeout_ms)
    @options = _init_options(producer_options)
    Kafka::validate_options(options, REQUIRED_OPTIONS, KNOWN_OPTIONS)
    @send_timeout = send_timeout_ms

    @producer = KAFKA_PRODUCER.new Kafka::create_config(options)
    @send_method = producer.java_method :send, [ProducerRecord]
  end

  def close
    producer.close
  end

  def send_message(topic, key, message)
    data = _create_data(message)
    _send_msg(ProducerRecord.new(topic, key, data))
  end

  def _create_data(message)
    message.to_json
  end

  def _send_msg_async(product_record)
    send_method.call(product_record)
  end

  def _send_msg(product_record)
    err = nil
    begin
      result = send_method.call(product_record).get(send_timeout, TimeUnit::MILLISECONDS)
    rescue Exception => e
      err = { error: e.message }
    end
    [result, err]
  end

  def _init_options(options)
    opts = options.dup
    opts['acks'] = opts.fetch('acks', '1')
    opts['retries'] = opts.fetch('retries', '0')
    opts['linger.ms'] = opts.fetch('linger.ms', '1')
    opts['key.serializer'] = opts.fetch('key.serializer', 'org.apache.kafka.common.serialization.StringSerializer')
    opts['value.serializer'] = opts.fetch('value.serializer', 'org.apache.kafka.common.serialization.StringSerializer')
    opts['bootstrap.servers'] = opts.fetch('bootstrap.servers', 'localhost:9092')
    opts
  end
end
