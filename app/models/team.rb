class Team
  include DataMapper::Resource

  property :id           , Serial
  property :slug         , String
  property :name         , String   , length: 0..32 , required: true
  property :created_at   , DateTime
  property :updated_at   , DateTime
end
