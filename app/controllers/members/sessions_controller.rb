class Members::SessionsController < Devise::SessionsController
  def new
    super
    session[:member_return_to] = params[:return_to] unless params[:return_to].blank?
  end

  def create
    super
    flash.discard
  end

  def destroy
    super
    flash.discard
  end
end

