require 'date'

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Delivering notifications created since last delivery"
  Notification.deliver_undelivered_notifications!
end