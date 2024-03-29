class SurveysSweeper < ActionController::Caching::Sweeper
  observe Survey

  def after_save(survey)
    Rails.cache.write :surveys_cache_expirary_key, rand.to_s[2..-1]
    expire_action survey_questions_url(:survey_id => survey)
  end

  def after_destroy(survey)
    Rails.cache.write :surveys_cache_expirary_key, rand.to_s[2..-1]
    expire_action survey_questions_url(:survey_id => survey)
  end
end