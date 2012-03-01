class PagesController < ApplicationController
  layout 'one_column'
  caches_action :show,
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}, 
    :expires_in => 15.minutes

  def show
    if @page = Page.find_by_url_and_state(params[:path], 'published')
      unless @page.redirect_url.blank?
        redirect_to @page.redirect_url.blank?
      end
    else
      render_404
    end
  end
  
  protected
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:pages_cache_expirary_key)
    end
end
