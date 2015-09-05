require 'bundler/setup'
Bundler.require
require 'pry'

class Sportiv < Sinatra::Base
  register Sinatra::Namespace

  enable :logging
  configure :production do
    disable :show_exception
  end

  configure :production, :development do
    # set :logging, Logger::DEBUG
  end

  error do
    haml :error, layout: true
  end

  not_found do
    haml :"404", layout: true
  end

  get "/500" do
    raise StandardError, "Intentional blow up!"
  end

  get '/' do
    haml :'pages/index', layout: true
  end

  get '/updates' do

  end

  configure do
    set :source_url, 'http://www.football-data.co.uk/mmz4281/1516/E0.csv'

    CSV::Converters[:date_to_iso] = lambda do |str|
      binding.pry
      begin
        Date.strptime(str, '%d/%m/%y').strftime('%Y-%m-%d')
      rescue Exception => e
        str
      end
    end
  end
end
