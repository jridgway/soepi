desc "Destroy old visitor surveys that visitors began creating but never finished"
task :destroy_old_visitor_surveys => :environment do
  Survey.destroy_old_visitor_surveys!
end