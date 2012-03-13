Refinery::PagesController.class_eval do 
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  caches_action :home, :show, 
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}
    
  protected
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:pages_cache_expirary_key)
    end
end