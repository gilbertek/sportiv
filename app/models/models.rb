env = ENV['RACK_ENV'] || 'development'
url = "sqlite://#{Dir.pwd}/db/#{env}.sqlite3"
DataMapper.setup :default, url

DataMapper::Logger.new($stdout, :debug)

class User
  include DataMapper::Resource

  property :id          , Serial
  property :uid         , String   , unique_index: true, default: lambda { |resource, prop| Digest::MD5.hexdigest("#{email}#{created_at}") }
  property :email       , String
  property :first_name  , String   , length: 0..32
  property :last_name   , String   , length: 0..32
  property :username    , String   , length: 0..32
  property :password    , String   , length: 0..128
  property :token       , String   , length: 0..128
  property :created_at  , DateTime
  property :updated_at  , DateTime
end

# Digest::MD5.hexdigest("#{hometeam}#{awayteam}#{Time.now}")
class Game
  include DataMapper::Resource

  property :id          , Serial
  property :slug        , String  , key: true, unique_index: true, default: lambda { |res, prop| "#{res.hometeam}-vs-#{res.awayteam}-#{res.start_date}".downcase.gsub(" ", "-") }
  property :start_date  , DateTime , required: true
  property :hometeam    , String   , length: 0..32 , required: true
  property :awayteam    , String   , length: 0..32 , required: true
  property :fthg        , Integer
  property :ftag        , Integer
  property :ftr         , String   , length: 0..8
  property :hthg        , Integer
  property :htag        , Integer
  property :htr         , String   , length: 0..8
  property :referee     , String   , length: 0..56
  property :created_at  , DateTime
  property :updated_at  , DateTime

  def self.from_row(row)
    payload = map_fields(row)
    # game = Game.first(payload)
    # if game.nil?
    #   Game.new(payload).save
    # else
    #   Game.update(payload)
    # end

    # binding.pry
    Game.first_or_create(payload).update(payload)
  end

  # private

  def self.map_fields(row)
    {
      start_date: row[:date],
      hometeam:   row[:hometeam],
      awayteam:   row[:awayteam],
      fthg:       row[:fthg],
      ftag:       row[:ftag],
      hthg:       row[:hthg],
      htag:       row[:htag],
      htr:        row[:htr],
      referee:    row[:referee],
      created_at: Time.now,
      updated_at: Time.now
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
