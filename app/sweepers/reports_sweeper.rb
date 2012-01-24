class ReportsSweeper < ActionController::Caching::Sweeper
  observe Report

  def after_save(report)
    Rails.cache.write :reports_cache_expirary_key, rand.to_s[2..-1]
  end

  def after_destroy(report)
    Rails.cache.write :reports_cache_expirary_key, rand.to_s[2..-1]
  end
end