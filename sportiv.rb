require 'bundler/setup'
Bundler.require
require 'net/http'
require 'uri'
require 'csv'
require 'json'
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

  get '/schedules' do
    @schedules = Game.all(order: [:start_date.desc])
    @schedules.to_json
  end

  get '/updates' do
    uri = URI.parse(settings.source_url)
    response = Net::HTTP.get_response(uri)
    csv = CSV.new(response.body, {
      headers: :first_row,
      header_converters: :symbol,
      converters: [:all, :date_to_iso]
    })

    keep = [:date, :hometeam, :awayteam, :fthg, :ftag, :ftr, :hthg, :htag, :htr, :referee]

    data = csv.to_a.map do
      |row| row.to_hash.select { |k, v| keep.include?(k) }
      Game.from_row(row)
    end

    # data.delete_if { |v| v[:ftr] == nil }

    # count = 0 #Get current count from db
    # records = data.length - count

    # if records > 0
      # Push notification!
      # remove existing row
      # insert new row
    # end

    { success: true, records: data.length }.to_json
  end

  configure do
    set :source_url, 'http://www.football-data.co.uk/mmz4281/1516/E0.csv'

    CSV::Converters[:date_to_iso] = lambda do |str|
      begin
        Date.strptime(str, '%d/%m/%y').strftime('%Y-%m-%d')
      rescue Exception => e
        # Logger.debug "Exception: #{e}: #{e.backtrace}"
        str
      end
    end
  end
end
