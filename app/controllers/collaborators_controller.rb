class CollaboratorsController < ApplicationController
  before_filter :authenticate_member_2!, :except => [:show]
  before_filter :load_collaborable, :except => [:show]
  before_filter :authorize!, :except => [:show]
  
  def show
    if collaborator = Collaborator.find_by_id_and_key(params[:id], params[:key])
      if collaborator.active? 
        if member_signed_in?
          if collaborator.member_id != current_member.id
            flash[:notice] = 'Sorry, this collaboration link has been actived for another member already.'
          end
        else
          flash[:notice] = "Please sign in for full access to this #{collaborator.collaborable_type.downcase}."
        end
      else
        if member_signed_in?
          current_member.apply_collaborator(collaborator)
          flash[:notice] = "Yay, you are now a collaborator for this #{collaborator.collaborable_type.downcase}."
        else
          cookies.encrypted[:collaborator_key] = collaborator.key
          flash[:notice] = "Almost finished... but first you must sign in or sign up to *collaborate* on this " +
            "#{collaborator.collaborable_type.downcase}."
        end
      end
    else 
      flash[:notice] = 'Sorry, your collaboration link is not valid. Please try again or contact us for help.'
    end
    case collaborator.collaborable_type.downcase
      when 'survey' then
        redirect_to survey_path(collaborator.collaborable)
      when 'report' then
        redirect_to survey_path(collaborator.collaborable)
    end
  end
  
  def new
    @collaborator = @collaborable.collaborators.build params[:collaborator]
  end
  
  def create 
    @collaborator = @collaborable.collaborators.create params[:collaborator]
  end
  
  def destroy 
    @collaborable.collaborators.destroy params[:id]
    @no_collaborators = @collaborable.collaborators.empty?
  end
  
  protected 
  
    def load_collaborable
      if params[:id].to_i > 0
        @collaborable = Collaborator.find(params[:id]).collaborable
      else
        case params[:collaborable_type]
          when 'Survey' then @collaborable = Survey.find(params[:collaborable_id])
          when 'Report' then @collaborable = Report.find(params[:collaborable_id])
        end
      end
    end 
    
    def authorize!
      unless current_member.admin? or current_member.id == @collaborable.member_id
        flash[:notice] = 'Insufficient permissions.'
        case @collaborable.class.to_s
          when 'Survey' then redirect_to_back_or(survey_path(Survey.find params[:collaborable_id]))
          when 'Report' then redirect_to_back_or(report_path(Survey.find params[:collaborable_id]))
          else redirect_to root_path
        end 
        false
      end
    end
end
