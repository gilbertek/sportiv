env = ENV['RACK_ENV'] || 'development'
url = "sqlite://#{Dir.pwd}/db/#{env}.sqlite3"
DataMapper.setup :default, url

DataMapper::Logger.new($stdout, :debug)

class User
  include DataMapper::Resource

  property :id          , Serial
  property :uid         , String
  property :email       , String
  property :first_name  , String   , length: 0..32
  property :last_name   , String   , length: 0..32
  property :username    , String   , length: 0..32
  property :password    , String   , length: 0..128
  property :token       , String   , length: 0..128
  property :created_at  , DateTime
  property :updated_at  , DateTime
end

 # {:date=>"2015-08-08", :hometeam=>"Leicester", :awayteam=>"Sunderland", :fthg=>4, :ftag=>2, :ftr=>"H", :hthg=>3, :htag=>0, :htr=>"H", :referee=>"L Mason
class Game
  include DataMapper::Resource

  property :id          , Serial
  property :uid         , String

  property :start_time  , DateTime , required: true

  property :created_at  , DateTime
  property :updated_at  , DateTime
  property :hometeam    , String   , length: 0..32 , required: true
  property :awayteam    , String   , length: 0..32 , required: true
  property :fthg        , Integer
  property :ftag        , Integer
  property :ftr         , String   , length: 0..8
  property :hthg        , Integer
  property :htag        , Integer
  property :htr         , String   , length: 0..8
  property :referee     , String   , length: 0..56

  def from_row(row)
    binding.pry
  end

  private

  def keep
    [:date, :hometeam, :awayteam, :fthg, :ftag, :ftr, :hthg, :htag, :htr, :referee]
  end

  def map(row)
    {
      title: row['title'],
    }
  end

end

class Team
  include DataMapper::Resource

  property :id           , Serial
  property :uid          , String
  property :name         , String   , length: 0..32 , required: true
  property :created_at   , DateTime
  property :updated_at   , DateTime
end

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!
