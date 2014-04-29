require 'twitter'
require 'optparse'

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.on("-t", "--tweet", "Tweet instead of printing") do |t|
        options[:tweet] = true
    end
end.parse!

titles = File.readlines("titles.txt")
template = "%s in the streets, %s in the sheets"

length = 141
while length > 140 do
    streets = titles.sample.chomp
    sheets = titles.sample.chomp
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
