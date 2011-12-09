class ReportsController < ApplicationController
  before_filter :authenticate_member!, :except => [:index, :show, :code, :output]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  def index 
    @reports = Report.page(params[:page]).per(10)
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
    flash[:notice] = 'Your report was deleted.'
    redirect_to root_path
  end
  
  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @reports = Report.tagged_with(@tag).page(params[:page])
    render :action => 'index'
  end
end
