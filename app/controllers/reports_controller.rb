class ReportsController < ApplicationController
  before_filter :load_report, :except => [:new, :create, :index, :pending, :published, :passing, :failing, :by_tag]
  before_filter :authenticate_member!, :except => [:index, :pending, :published, :passing, :failing, :by_tag, :show, :view_code, :output]
  before_filter :owner_only, :only => [:edit, :update, :destroy, :publish, :code, :save_and_run, :save_and_continue, :save_and_exit]
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_facebook_meta, :only => [:show, :code, :output, :edit, :update]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  def index 
    @reports = Report.published.page(params[:page]).per(10)
    render :layout => 'two_column'
  end
  
  def pending 
    @reports = Report.pending.page(params[:page]).per(10)
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
  
  def edit
  end 
  
  def update
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
  
  def save_and_run
    @report.update_attribute :code, params[:report][:code] if params[:report] and params[:report][:code]
    @job_id = params[:job_id]
    if current_member.get_ec2_instance.try(:state).to_s == 'running'
      unless @report.preparing_to_run? or params[:job_id]
        @report.prepare_to_run!
        @job_id = @report.delay.run!.id
      end
    else
      current_member.transaction do 
        if not current_member.booting_ec2_instance?
          current_member.update_attribute :booting_ec2_instance, true
          current_member.delay.create_ec2_instance!
        end
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
  
  def publish 
    @report.publish!
    flash[:notice] = 'Your report was published.'
    redirect_to report_path(@report)
  end  
  
  protected 
  
    def load_report
      @report ||= Report.find params[:id]
    end 
  
    def owner_only
      load_report unless @report      
      unless member_signed_in? and current_member.id == @report.member_id
        flash[:alert] = 'Permission denied.'
        redirect_to reports_path
      end
    end   

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
