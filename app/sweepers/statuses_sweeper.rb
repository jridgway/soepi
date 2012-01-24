class StatusesSweeper < ActionController::Caching::Sweeper
  observe MemberStatus

  def after_save(status)
    Rails.cache.write :statuses_cache_expirary_key, rand.to_s[2..-1]
  end

  def after_destroy(status)
    Rails.cache.write :statuses_cache_expirary_key, rand.to_s[2..-1]
  end
end