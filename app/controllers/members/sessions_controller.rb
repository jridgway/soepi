class Members::SessionsController < Devise::SessionsController
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
  end
end

