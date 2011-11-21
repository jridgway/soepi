class SearchController < ApplicationController
  def index
    @q = params[:q]
    @results = Sunspot.search([Survey, Participant, RScript, Report, Member, Page]) do 
      keywords @q
      with :published, true
      paginate :page => params[:page], :per_page => 10
    end
    render :layout => 'one_column'
  end

  def quick_search
    @term = params[:term].to_s.split(' ').collect {|s| s.strip + '*'}.join(' ')
    @results = Sunspot.search([Survey, Participant, RScript, Report, Member, Page]) do 
      keywords @term
      with :published, true
      paginate :page => params[:page], :per_page => 10
    end
  end
end
