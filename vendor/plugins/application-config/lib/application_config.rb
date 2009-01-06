require 'yaml'

$__app_config = Hash.new

module ApplicationConfig
  def self.load(config_file = File.join(RAILS_ROOT, 'config/application_config.yml'))
    if File.exists?(config_file)
      $__app_config = YAML.load_file(config_file)
    else
      raise("ApplicationConfig plugin: no configiguration file found at path: #{config_file}")
    end 
  end
end

module Kernel
  def property(key)
    $__app_config[RAILS_ENV][key.to_s] 
    rescue raise("Failed to get '#{key}' configuration property")
  end
  alias_method :prop, :property
end
