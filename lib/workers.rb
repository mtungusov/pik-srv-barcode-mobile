require 'celluloid/current'
require_relative 'kafka'

module Workers; end
require_relative 'workers/consumer'

module Workers

  module_function

  def start_all
    _config_all
    _process_all
  end

  def shutdown
    Celluloid::Actor[:kafka_consumer].wakeup
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

    @config ||= Celluloid::Supervision::Configuration.define([
      {
         type: Workers::Consumer,
         as: :kafka_consumer,
         args: [consumer_options, topics]
      }
    ])

    @config.deploy
  end

  def _process_all
    Celluloid::Actor[:kafka_consumer].async.process
  end

end
