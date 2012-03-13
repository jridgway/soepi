Refinery::PageSweeper.class_eval do 
  protected
  
    def expire_cache
      Rails.cache.write :pages_cache_expirary_key, rand.to_s[2..-1]
    end
end