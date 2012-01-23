desc "Deliver notifications"
task :deliver_notifications => :environment do
  Notification.deliver_notifications!
end