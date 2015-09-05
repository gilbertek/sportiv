env = ENV['RACK_ENV'] || 'development'
url = "sqlite://#{Dir.pwd}/db/#{env}.sqlite3"
DataMapper.setup :default, url

DataMapper::Logger.new($stdout, :debug)

class User
  include DataMapper::Resource

  property :id           , Serial
  property :uid          , String
  property :email        , String
  property :name         , String   , length: 0..56
  property :nickname     , String   , length: 0..32
  property :created_at   , DateTime
  property :updated_at   , DateTime
end

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!
