class Members::SessionsController < Devise::SessionsController
  before_filter :load_surveys, :only => [:new, :create]
  
  def new
    super
    session[:member_return_to] = params[:return_to] unless params[:return_to].blank?
  end

  def create
    super
    unless cookies.encrypted[:collaborator_key].blank?
      if collaborator = Collaborator.find_by_key(cookies.encrypted[:collaborator_key])
        current_member.apply_collaborator(collaborator)
        cookies.encrypted[:collaborator_key] = nil
      end
    end
    if session[:survey_ids] and not session[:survey_ids].empty?
      Survey.where('id in (?) and (member_id = 0 or member_id is null)', session[:survey_ids]).
        update_all "member_id = #{current_member.id}"
      session[:survey_ids] = nil
    end
  end
  
  protected
    
    def load_surveys
      if session[:survey_ids] and session[:survey_ids].length > 0
        @surveys = Survey.where('id in (?) and (member_id = 0 or member_id is null)', session[:survey_ids]).limit(3)
      end
    end
end

