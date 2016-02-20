require "java"

java_import java.lang.System

puts "Start App"
puts "Java:  #{System.getProperties["java.runtime.version"]}"
puts "Jruby: #{ENV['RUBY_VERSION']}"

$root_dir = "#{__dir__}"
puts "Dir: #{$root_dir}"

require_relative "lib/settings"
puts "Namespace: #{Settings.namespace}"
puts "App: #{$settings.app_name}"

require_relative "lib/trap_signals"

# require_relative 'lib/workers'
# Workers.start_all

require_relative 'lib/kafka'
consumer_options = {
  'bootstrap.servers' => $settings.connection.kafka,
  'group.id' => 'srv-barcode-mobile-consumer-nsi',
  'client.id' => "#{$settings.app_name}-nsi-#{Settings.namespace}-#{(1..5).map { rand 9 }.join}"
}

p java.lang.Long::MAX_VALUE

# require 'pry'
# binding.pry

$consumer = Kafka::Consumer.new consumer_options
topics = [$consumer.gen_topic_partition('1s-references-podrazdeleniya')]

require_relative "lib/at_exit_actions"
$run = true
begin
  $consumer.assign topics
  topics.each { |t| $consumer.seek_to_beginning t }
  loop do
    records = $consumer.poll(java.lang.Long::MAX_VALUE)
    records.forEach do |record|
      p "key: #{record.key}, value: #{record.value}, offset: #{record.offset}, topic: #{record.topic}"
    end
  end
rescue org.apache.kafka.common.errors.WakeupException
  p "Wakeup"
rescue
  p "Other exception"
ensure
  p "Consumer close"
  $consumer.close
end



# require_relative "lib/api"
# run API::App

