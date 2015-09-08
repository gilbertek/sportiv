class User
  include DataMapper::Resource

  property :id          , Serial
  property :uid         , String   , unique_index: true, default: lambda { |resource, prop| Digest::MD5.hexdigest("#{email}") }
  property :email       , String
  property :first_name  , String   , length: 0..32
  property :last_name   , String   , length: 0..32
  property :username    , String   , length: 0..32
  property :password    , String   , length: 0..128
  property :token       , String   , length: 0..128
  property :created_at  , DateTime
  property :updated_at  , DateTime
end
