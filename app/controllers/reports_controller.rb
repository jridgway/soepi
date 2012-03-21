class ReportsController < ApplicationController
  before_filter :load_report, :except => [:new, :create, :index, :pending, :published, :passing, :failing, :by_tag]
  before_filter :authenticate_member!, :except => [:index, :pending, :published, :passing, :failing, 
    :by_tag, :show, :view_code, :output, :surveys, :forks]
  before_filter :owner_only, :only => [:edit, :update, :destroy, :publish, :code, :results,
    :save_and_run, :save_and_continue, :save_and_exit]
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_open_graph_meta, :except => [:new, :create, :index, :pending, :published, :passing, :failing, :by_tag]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  caches_action :index, :pending, :published, :passing, :failing, :by_tag, :show, :view_code, :output, :surveys, :forks, 
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}, 
    :expires_in => 2.hours
  cache_sweeper :reports_sweeper, :only => [:create, :update, :destroy, :save_and_run, :save_and_continue, 
    :save_and_exit, :forkit, :publish]
  
  def index 
    @reports = Report.published.page(params[:page])
    render :layout => 'two_column'
  end
  
  def pending 
    @reports = Report.pending.page(params[:page])
    render :action => 'index'
  end
  
  def published
    @reports = Report.published.page(params[:page])
    render :action => 'index'
  end
  
  def passing
    @reports = Report.passing.page(params[:page])
    render :action => 'index', :layout => 'two_column'
  end
  
  def failing
    @reports = Report.failing.page(params[:page])
    render :action => 'index', :layout => 'two_column'
  end
  
  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @reports = Report.tagged_with(@tag).page(params[:page])
    render :action => 'index', :layout => 'two_column'
  end
  
  def new 
    @report = current_member.reports.build params[:report]
  end
  
  def create 
    @report = current_member.reports.build params[:report]
    if @report.save 
      flash[:notice] = 'Your report was created. You may now begin writing code to generate plots.'
      redirect_to code_report_path(@report)
    else
      render :action => 'new'
    end
  end
  
  def show
  end
  
  def code
    render :layout => 'two_column'
  end
  
  def view_code
  end
  
  def output
  end
  
  def surveys
    @surveys = @report.surveys.page(params[:page])
  end

  def forks
    @forks = @report.forks.page(params[:page])
    render :layout => 'one_column'
  end
  
  def edit
  end 
  
  def update
    if @report.update_attributes params[:report] 
      if params[:commit] == 'Publish' and @report.passing?       
        @report.publish!
        flash[:notice] = 'Your report was saved and published.'
      else
        flash[:notice] = 'Your report was saved.'
      end
      redirect_to report_path(@report)
    else
      render :action => 'edit'
    end
  end
  
  def destroy 
    current_member.reports.destroy params[:id]
    if request.xhr?
      render :text => "$('#run-results').remove();"
    else
      flash[:notice] = 'Your report was deleted.'
      redirect_to root_path
    end
  end
  
  def save_and_run
    @report.update_attribute :code, params[:report][:code] if params[:report] and params[:report][:code]
    current_member.transaction do 
      unless @report.job or @report.running?
        @job_id = @report.delay.run!.id
        @report.update_attribute :job_id, @job_id
      end
    end
  end 
  
  def save_and_continue
    @report.update_attribute :code, params[:report][:code]
  end 
  
  def save_and_exit
    @report.update_attribute :code, params[:report][:code]
    flash[:notice] = 'Your report was saved.'
    redirect_to report_path(@report)
  end 

  def forkit
    new_report = @report.forkit!(current_member.id)
    flash[:alert] = %{You forked report, #{@report.title}. You now have your own copy of the report.}
    redirect_to code_report_path(new_report)
  end 
  
  protected 
  
    def load_report
      @report ||= Report.find params[:id]
    rescue 
      error_404
      false
    end 
  
    def owner_only    
      unless member_signed_in? and current_member.id == @report.member_id
        flash[:alert] = 'Permission denied.'
        redirect_to reports_path
      end
    end   

    def load_tags
      @tags = Report.published.tag_counts :start_at => 2.months.ago, :limit => 100
    end

    def load_open_graph_meta
      @open_graph_meta = {
        :url => report_url(@report),
        :title => @report.title,
        :description => @report.introduction,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'Report'
      }
    end
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:reports_cache_expirary_key)
    end
end
