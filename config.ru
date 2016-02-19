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

require_relative "lib/api"
run API::App

require_relative "lib/at_exit_actions"
