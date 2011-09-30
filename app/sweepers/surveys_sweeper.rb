class SurveysSweeper < ActionController::Caching::Sweeper
  observe Survey

  def after_save(survey)
    expire_fragment %r{views/.*#{surveys_path}(/.*)?}
  end
end