class PagesController < ApplicationController
  layout 'two_column_wide'

  def show
    if @page = Page.find_by_slug_and_state(params[:id], 'published')
      unless @page.redirect_url.blank?
        redirect_to @page.redirect_url.blank?
      end
    else
      render_404
    end
  end
end
