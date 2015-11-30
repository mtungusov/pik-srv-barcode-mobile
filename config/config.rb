require 'yaml'

module Configuration
  def self.load_config(env)
    config_file = 'config/config.yml'
    File.exist?(config_file) ? YAML.load_file(config_file)[env] : {}
  end
end
