require 'twitter'
require 'optparse'

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.on("-t", "--tweet", "Tweet instead of printing") do |t|
        options[:tweet] = true
    end
end.parse!

keys = File.readlines("tv_shows.txt")
template = "%s in the streets, %s in the sheets"

def pick_season(max)
  (1..max.to_i).to_a.sample
end

length = 141
while length > 140 do
    streetsraw = keys.sample.chomp.split(',')
    sheetsraw = keys.sample.chomp.split(',')
    streets = "#{streetsraw.first} Season #{pick_season(streetsraw.last)}"
    sheets = "#{sheetsraw.first} Season #{pick_season(sheetsraw.last)}"
    length = (template.length - 4) + streets.length + sheets.length
end

client = Twitter::REST::Client.new do |config|
    config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
    config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

if options[:tweet] then
    client.update(template % [streets, sheets])
else
    puts template % [streets, sheets]
end
