class RScriptInputsController < ApplicationController
  before_filter :authenticate_member!
  before_filter :load_r_script
  
  def new 
    @r_script_input = @r_script.inputs.build params[:r_script_input]
  end
  
  def create 
    @r_script_input = @r_script.inputs.build params[:r_script_input]
    @r_script_input.save
  end 
  
  def edit
    @r_script_input = @r_script.inputs.find params[:id]
  end 
  
  def update
    @r_script_input = @r_script.inputs.find params[:id]
    @r_script_input.update_attributes params[:r_script_input] 
  end
  
  def destroy 
    @r_script_input = @r_script.inputs.find params[:id]
    @r_script_input.destroy
  end
  
  def surveys_auto_complete
    @results = Survey.search do
      keywords params[:term]
      with :published, true
      paginate :page => params[:page], :per_page => 50
    end
  end
  
  protected
  
    def load_r_script
      if current_member.admin?
        @r_script = RScript.find params[:r_script_id]
      else
        @r_script = current_member.r_scripts.find params[:r_script_id]
      end
    end
end
