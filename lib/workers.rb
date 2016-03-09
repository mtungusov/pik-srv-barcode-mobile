require 'celluloid/current'
require_relative 'kafka'

module Workers; end
require_relative 'workers/consumer'
require_relative 'workers/producer'

module Workers
  module_function

  def start_all
    p 'Start Workers'
    _config_all
    _process_all
  end

  def shutdown
    p 'Shutdown Workers'
    Celluloid::Actor[:kafka_consumer].wakeup
    Celluloid::Actor[:kafka_producer].close
    @config.shutdown
  end

  def _config_all
    consumer_options = {
      'bootstrap.servers' => $settings.connection.kafka,
      'group.id' => "#{$settings.app_name}-nsi-#{Settings.namespace}",
      'client.id' => "#{$settings.app_name}-nsi-#{Settings.namespace}-#{(1..5).map { rand 9 }.join}"
    }
    topics = [
        '1s-references-podrazdeleniya',
        '1s-references-sotrudniki',
        'barcode-production-in'
    ]

    timeout = $settings.connection.timeout_in_ms
    producer_opts = {
        'bootstrap.servers' => $settings.connection.kafka,
        'client.id' => "#{$settings.app_name}-#{Settings.namespace}-#{(1..5).map { rand 9 }.join}"
    }

    @config ||= Celluloid::Supervision::Configuration.define([
      {
         type: Workers::Consumer,
         as: :kafka_consumer,
         args: [consumer_options, topics]
      },
      {
        type: Workers::Producer,
            as: :kafka_producer,
            args: [producer_opts, timeout]
      }
    ])
  end

  def _process_all
    @config.deploy
    Celluloid::Actor[:kafka_consumer].async.process
  end
end

require_relative 'workers/operations'
