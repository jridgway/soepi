class Statistic
  @@demos = [AgeGroup, Ethnicity, Race, Education]
  
  class << self
    def get_or_compute(key)
      if value = REDIS.get(key)
        YAML::load value 
      else
        value = compute_and_set(key)
      end
    end 
    
    def compute_and_set(key)
      function, params = parse_key(key)
      value = self.send(function, params)
      set(key, value)
      value
    end
    
    def get(key)
      YAML::load REDIS.get(key)
    end
    
    def set(key, value)
      REDIS.set(key, value.to_yaml)
      value
    end
    
    def inc(key)
      REDIS.incr key
    end 
    
    def delete(key)
      REDIS.del key
    end
    
    def delete_all
      REDIS.flushall
    end
    
    private
    
      def parse_key(key)
        parts = key.split('|')
        function = parts.first 
        params = {}
        parts = parts.last.split(',')
        parts.each do |kv|
          kv2 = kv.split(':')
          params[kv2.first.to_sym] = kv2.last
        end
        return function.to_sym, params
      end
      
      def survey_completes(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).count
      end
      
      def survey_incompletes(params)
        ParticipantSurvey.where('survey_id = ? and complete = false', params[:id]).count
      end
      
      def survey_completes_by_gender(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).group('gender_id').count
      end
      
      def survey_completes_by_age_group(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).group('age_group_id').count
      end
      
      def survey_completes_by_education(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).group('education_id').count
      end
      
      def survey_completes_by_ethnicity(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).
          joins('join ethnicities_participant_surveys eps on eps.participant_survey_id = participant_surveys.id').
          group('ethnicity_id').count
      end
      
      def survey_completes_by_race(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).
          joins('join participant_surveys_races psr on psr.participant_survey_id = participant_surveys.id').
          group('race_id').count
      end
      
      def survey_completes_by_region(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).group('region_id').count
      end
      
      def survey_completes_by_state(params)
        ParticipantSurvey.where('survey_id = ? and complete = true', params[:id]).group('state').count
      end
  end
end