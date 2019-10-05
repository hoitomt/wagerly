namespace :tickets do
  desc "Get ticket data for all time"
  task :get_all => :environment do
    puts "Get all ticket data"
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    tickets = sb.all_tickets
  end

  desc "Get ticket data for the past 30 days"
  task :get_recent => :environment do
    puts "Get all ticket data"
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    tickets = sb.recent_tickets(Date.today)
  end
end
