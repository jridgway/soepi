class SearchController < ApplicationController
  def index
    @q = params[:q]
    @results = Tanker.search([Survey, Chart, Petition, Member], @q, 
      :conditions => {:published => true}, :page => params[:page], :per_page => 10)
    render :layout => 'one_column'
  end

  def quick_search
    @term = params[:term].to_s.split(' ').collect {|s| s.strip + '*'}.join(' ')
    @results = Tanker.search([Survey, Chart, Petition, Member], @term,
      :conditions => {:published => true}, :limit => 10)
  end
end
