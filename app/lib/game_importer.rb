#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'csv'
require 'json'

class GameImporter
  def self.import(url, &block)
    raise "Unable to import game data" unless url.present?

    CSV.new(open(url), {
      headers: :first_row,
      header_converters: :symbol,
      converters: [:all, :date_to_iso]
    }).each do |row|
      gm = Game.from_row(row)
      yield gm if block_given?
    end
  end

  def csv_converters
    CSV::Converters[:date_to_iso] = lambda do |str|
        begin
          Date.strptime(str, '%d/%m/%y').strftime('%Y-%m-%d')
        rescue Exception => e
          Logger.debug "Exception: #{e}: #{e.backtrace}"
          str
        end
      end
    end
  end
end
