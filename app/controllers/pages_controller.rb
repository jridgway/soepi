class PagesController < ApplicationController
  layout 'one_column'
  caches_action :show,
    :cache_path => Proc.new {|controller| controller.params}, 
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
end
