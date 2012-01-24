class SearchController < ApplicationController
  def index
    @q = params[:q]
    @results = Sunspot.search([Member, Survey, Report, Page]) do 
      keywords params[:q]
      with :published, true
      paginate :page => params[:page], :per_page => 10
    end
    render :layout => 'one_column'
  end

  def quick_search
    @term = params[:term]
    @results = Sunspot.search([Member, Survey, Report, Page]) do 
      keywords params[:term]
      with :published, true
      paginate :page => params[:page], :per_page => 10
    end
  end
end
