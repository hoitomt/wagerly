namespace :bets do
  desc 'Fetch all bets from URL'
  task :fetch_from_url, [:url] => [:environment] do |task, args|
    raise "Please provide a url in the format bets:fetch_from_url['<url>']" unless args[:url]
    url = args[:url]
    puts "Get all bets from #{url}"
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    puts sb.bets_for_url(url)
  end
end
