require 'bundler/setup'
Bundler.require

class Sportiv < Sinatra::Base
  get "/" do
    "Hello"
  end
end
