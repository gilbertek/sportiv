env = ENV['RACK_ENV'] || 'development'
url = "sqlite://#{Dir.pwd}/db/#{env}.sqlite3"
DataMapper.setup :default, url
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true

require_relative 'user'
require_relative 'game'
require_relative 'team'

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!
