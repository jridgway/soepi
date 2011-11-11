namespace :survey do
  namespace :results do
    desc "Inspect a survey to find and mark results that may compromise our members' anonymity"
    task :mark_non_anonymous => :environment do
      raise 'ID env variable required' if ENV['ID'].blank?
      survey = Survey.find(ENV['ID'])
      raise 'Survey still open' if survey.launched?
      ParticipantSurvey.where(%{
          old_city is not null or old_state is not null or old_postal_code is not null or 
          old_region_id is not null or destroy_participant_survey = true
        }).update_all(%{
          city = old_city, old_city = null,
          postal_code = old_postal_code, old_postal_code = null,
          state = old_state, old_state = null,
          region_id = old_region_id, old_region_id = null,
          destroy_participant_survey = false
        })
      demos = %w{age_group_id gender_id education_id race_ids_cache ethnicity_ids_cache}
      address_parts = %w{city state postal_code region_id country}
      (0..(address_parts.length-1)).each do |i|
        address_parts_group = address_parts[i..(address_parts.length-1)]
        case i
          when 0 then update_sql = 'old_city = city, city = null'
          when 1 then update_sql = 'old_state = state, state = null'
          when 2 then update_sql = 'old_postal_code = postal_code, postal_code = null'
          when 3 then update_sql = 'old_region_id = region_id, region_id = null'
          else update_sql = 'destroy_participant_survey = true'
        end
        groups = ParticipantSurvey.where(:survey_id => survey.id).select(address_parts_group.join(', ')).group(address_parts_group.join(', ')).having('count(*) < ?', 10)
        process_groups(groups, update_sql)
        demos_and_address_parts_group = demos + address_parts_group
        groups = ParticipantSurvey.where(:survey_id => survey.id).select(demos_and_address_parts_group.join(', ')).group(demos_and_address_parts_group.join(', ')).having('count(*) < ?', 10)
        process_groups(groups, update_sql)
      end
    end
    
    def process_groups(groups, update_sql)
      groups.each do |group|
        where_statement = [group.attributes.collect {|a| "#{a.first} = ?"}.join(' and ')] +
          group.attributes.collect {|a| a.second}
        totals = ParticipantSurvey.where(where_statement).update_all(update_sql)
        puts "Process #{totals} participant surveys with #{update_sql} and group:\n#{group.to_yaml}"
      end
    end
    
    desc "Remove results marked non-anonymous"
    task :remove_non_anonymous => :environment do |t, args|
      raise 'ID env variable required' if ENV['ID'].blank?
      survey = Survey.find(ENV['ID'])
      raise 'Survey still open' if survey.launched?
      count = ParticipantSurvey.where('survey_id = ? and destroy_participant_survey = true', ENV['ID']).destroy_all
      puts "Destroyed #{count} results marked non-anonymous"
    end
    
    desc "Remove incompletes"
    task :remove_incompletes => :environment do |t, args|
      raise 'ID env variable required' if ENV['ID'].blank?
      survey = Survey.find(ENV['ID'])
      raise 'Survey still open' if survey.launched?
      count = ParticipantSurvey.where('survey_id = ? and complete = false', ENV['ID']).destroy_all
      puts "Destroyed #{count} incompletes"
    end
    
    desc "Mark review-completed-at=now()"
    task :remove_incompletes => :environment do |t, args|
      raise 'ID env variable required' if ENV['ID'].blank?
      survey = Survey.find(ENV['ID'])
      raise 'Survey still open' if survey.launched?
      survey.update_attribute :review_completed_at, Time.now
    end
  end
end