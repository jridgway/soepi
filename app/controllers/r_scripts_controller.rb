class RScriptsController < ApplicationController
  before_filter :authenticate_member!, :except => [:index, :show]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  def index 
    @r_scripts = RScript.page(params[:page]).per(10)
  end
  
  def new 
    @r_script = RScript.new params[:r_script]
  end
  
  def create 
    @r_script = current_member.r_scripts.build params[:r_script]
    if @r_script.save 
      flash[:notice] = 'Your R script was saved.'
      redirect_to r_script_path(@r_script)
    else
      render :action => 'new'
    end
  end 
  
  def show
    @r_script = RScript.find params[:id]
    render :layout => 'two_column'    
  end
  
  def edit
    @r_script = current_member.r_scripts.find params[:id]
  end 
  
  def update
    @r_script = current_member.r_scripts.find params[:id]
    if @r_script.update_attributes params[:r_script] 
      flash[:notice] = 'Your R script was saved.'
      redirect_to r_script_path(@r_script)
    else
      render :action => 'edit'
    end
  end
  
  def destroy 
    current_member.r_scripts.destroy params[:id]
    flash[:notice] = 'Your script was deleted.'
    redirect_to root_path
  end
  
  def code
    @r_script = current_member.r_scripts.find params[:id]
    render :layout => 'two_column'    
  end 
  
  def save_and_run
    @r_script = current_member.r_scripts.find params[:id]
    @r_script.update_attribute :code, params[:r_script][:code]
    run_helper
    render :action => 'run'
  end 
  
  def save_and_continue
    @r_script = current_member.r_scripts.find params[:id]
    @r_script.update_attribute :code, params[:r_script][:code]
  end 
  
  def save_and_exit
    @r_script = current_member.r_scripts.find params[:id]
    @r_script.update_attribute :code, params[:r_script][:code]
    flash[:notice] = 'Your R script was saved.'
    redirect_to r_script_path(@r_script)
  end 
  
  def run 
    @r_script = RScript.find params[:id]  
    run_helper
  end
  
  def by_tag
  end
  
  def forkit
    new_r_script = RScript.find(params[:id]).forkit!(current_member.id)
    flash[:alert] = %{You forked R script, #{new_r_script.title}. You now have your own copy of the R script.
      You can make any edits you wish.}
    redirect_to r_script_path(new_r_script)
  end
  
  protected 
    
    def run_helper
      if current_member.get_ec2_instance.try(:state).to_s == 'running'
        if params[:report_id].to_i > 0
          @report = Report.find params[:report_id]
        else
          @report = current_member.reports.create :r_script_id => @r_script.id, :code => @r_script.code, 
            :title => "#{@r_script.title} run at #{Time.now}"
          @report.delay.run!
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
end
