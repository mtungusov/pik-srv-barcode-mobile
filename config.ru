require 'java'

java_import java.lang.System

puts "Start App"
puts "Java:  #{System.getProperties["java.runtime.version"]}"
puts "Jruby: #{ENV['RUBY_VERSION']}"

$root_dir = "#{__dir__}"
puts "Dir: #{$root_dir}"

require_relative 'lib/settings'
puts "Namespace: #{Settings.namespace}"
puts "App: #{$settings.app_name}"

require_relative 'lib/db'

params = { host: $settings.sqlserver.host, db: $settings.sqlserver.db, user: $settings.sqlserver.user, pass: $settings.sqlserver.pass }
Db.con params

require_relative 'lib/validator'

# require 'pry'
# binding.pry

# require_relative 'lib/trap_signals'

# require_relative 'lib/cache'
# Cache::pool({ url: $settings.connection.redis })

# require_relative 'lib/workers'
# Workers.start_all

require_relative 'lib/api'
run API::App

require_relative 'lib/at_exit_actions'
