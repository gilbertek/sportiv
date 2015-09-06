require 'rubygems'
require 'bundler'
Bundler.require(:defaults)

require './sportiv'
require './app/models/models'

def config_for_env(hash)
  hash
end

file = File.expand_path(File.join File.dirname(__FILE__), "./config/config.yml")
if File.exist? file
  YAML.load_file(file).each do |key,value|
      warn "-> #{key}"
      config_for_env(value)
      #ENV[key.upcase] = value
  end
end

run Rack::URLMap.new("/" => Sportiv)
