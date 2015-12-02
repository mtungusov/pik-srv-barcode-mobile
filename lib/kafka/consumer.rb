require 'kafka'

class Kafka::Consumer
  java_import org.apache.kafka.clients.producer.ProducerRecord

  KAFKA_CONSUMER = Java::org.apache.kafka.clients.consumer.KafkaConsumer

  REQUIRED_OPTIONS = %w[
    bootstrap.servers
    group.id
    key.deserializer
    value.deserializer
  ]

  KNOWN_OPTIONS = %w[
    bootstrap.servers
    key.deserializer
    value.deserializer
    group.id
    auto.offset.reset
    enable.auto.commit
    auto.commit.interval.ms
    session.timeout.ms
    auto.offset.reset
  ]

  attr_reader :options, :consumer

  def initialize(consumer_options)
    @options = _init_options(consumer_options)
    Kafka::validate_options(options, REQUIRED_OPTIONS, KNOWN_OPTIONS)

    @consumer = KAFKA_CONSUMER.new Kafka::create_config(options)
  end

  def subscribe(topics)
    consumer.subscribe(topics)
  end

  def poll(timeout=100)
    consumer.poll timeout
  end

  def close
    consumer.close
  end

  def _init_options(options)
    opts = options.dup
    opts['bootstrap.servers'] = opts.fetch('bootstrap.servers', 'localhost:9092')
    opts['key.deserializer'] = opts.fetch('key.deserializer', 'org.apache.kafka.common.serialization.StringDeserializer')
    opts['value.deserializer'] = opts.fetch('value.deserializer', 'org.apache.kafka.common.serialization.StringDeserializer')
    opts['enable.auto.commit'] = opts.fetch('enable.auto.commit', 'true')
    opts['auto.commit.interval.ms'] = opts.fetch('auto.commit.interval.ms', '1000')
    opts['auto.offset.reset'] = opts.fetch('auto.offset.reset', 'latest')
    opts
  end
end