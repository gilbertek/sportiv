# Digest::MD5.hexdigest("#{hometeam}#{awayteam}#{Time.now}")
class Game
  include DataMapper::Resource

  property :id          , Serial
  property :slug        , String  , key: true, unique_index: true, default: lambda { |res, prop| "#{res.hometeam}-vs-#{res.awayteam}-#{res.start_date.strftime('%Y-%m-%d')}".downcase.gsub(" ", "-") }
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
    game = Game.first(payload)
    if game.nil?
      game = Game.create(payload)
    else
      Game.update(payload)
    end

    game
  end

  private

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
