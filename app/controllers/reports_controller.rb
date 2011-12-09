class ReportsController < ApplicationController
  before_filter :authenticate_member!, :except => [:index, :show, :code, :output]
  before_filter :admin_only!, :only => [:drafting]
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_facebook_meta, :only => [:show, :code, :output, :edit, :update]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  def index 
    @reports = Report.published.page(params[:page]).per(10)
    render :layout => 'two_column'
  end
  
  def drafting 
    @reports = Report.drafting.page(params[:page]).per(10)
    render :action => 'index'
  end
  
  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @reports = Report.tagged_with(@tag).page(params[:page])
    render :action => 'index'
    render :layout => 'two_column'
  end
  
  def show
    @report = Report.find params[:id]  
  end
  
  def code
    @report = Report.find params[:id] 
  end
  
  def output
    @report = Report.find params[:id] 
  end
  
  def edit
    @report = current_member.reports.find params[:id]
  end 
  
  def update
    @report = current_member.reports.find params[:id]
    if @report.update_attributes params[:report] 
      flash[:notice] = 'Your report was saved.'
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
  
  def publish 
    @report = current_member.reports.find(params[:id])
    @report.publish!
    flash[:notice] = 'Your report was published.'
    redirect_to report_path(@report)
  end
  
  protected    

    def load_tags
      @tags = Report.published.tag_counts :start_at => 2.months.ago, :limit => 100
    end

    def load_facebook_meta
      @report = Report.find params[:id] 
      @facebook_meta = {
        :url => report_url(@report),
        :title => @report.title,
        :description => @report.introduction,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'Report'
      }
    end
end
