class Kafka::Consumer
  java_import org.apache.kafka.common.TopicPartition

  KAFKA_CONSUMER = Java::OrgApacheKafkaClientsConsumer::KafkaConsumer
  # KAFKA_CONSUMER = Java::org.apache.kafka.clients.consumer.KafkaConsumer

  REQUIRED_OPTIONS = %w[
    bootstrap.servers
    client.id
    group.id
    key.deserializer
    value.deserializer
  ]

  KNOWN_OPTIONS = %w[
    auto.commit.interval.ms
    auto.offset.reset
    bootstrap.servers
    client.id
    enable.auto.commit
    group.id
    key.deserializer
    session.timeout.ms
    value.deserializer
  ]

  attr_reader :consumer

  def initialize(consumer_options)
    @consumer = KAFKA_CONSUMER.new(Kafka::Helpers::create_config(_init_options(consumer_options)))
  end

  def subscribe(topics)
    @consumer.subscribe(topics)
  end

  def assign(topics)
    @consumer.assign topics
  end

  def poll(timeout=100)
    @consumer.poll timeout
  end

  def close
    @consumer.close
  end

  def wakeup
    @consumer.wakeup
  end

  def gen_topic_partition(topic, partition=0)
    TopicPartition.new topic, partition
  end

  def seek_to_beginning(topics)
    @consumer.seekToBeginning topics
  end

  private

  def _init_options(options)
    opts = options.dup
    opts['bootstrap.servers'] = opts.fetch('bootstrap.servers', 'localhost:9092')
    opts['key.deserializer'] = opts.fetch('key.deserializer', 'org.apache.kafka.common.serialization.StringDeserializer')
    opts['value.deserializer'] = opts.fetch('value.deserializer', 'org.apache.kafka.common.serialization.StringDeserializer')
    opts['enable.auto.commit'] = opts.fetch('enable.auto.commit', 'true')
    opts['auto.commit.interval.ms'] = opts.fetch('auto.commit.interval.ms', '1000')
    opts['auto.offset.reset'] = opts.fetch('auto.offset.reset', 'latest')
    Kafka::Helpers::validated_options(opts, REQUIRED_OPTIONS, KNOWN_OPTIONS)
  end
end
