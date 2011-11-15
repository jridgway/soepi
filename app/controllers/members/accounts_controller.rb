class Members::AccountsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :except => [:new, :create, :load_current_member]
  layout Proc.new { |controller| 
    %w{new create}.include?(controller.action_name) ? 'two_column' : (controller.request.xhr? ? 'ajax' : 'one_column')
  }

  def create
    super
    unless @member.new_record?
      session[:omniauth] = nil
      session[:omniauth_user_hash] = nil
    end
  end

  def update
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to edit_member_registration_path
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  def change_password
    @member = current_member
  end

  def update_password
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => member_change_password_path
    else
      clean_up_passwords(resource)
      render_with_scope :change_password
    end
  end

  def subscriptions
    @member = current_member
  end

  def update_subscriptions
    @member = current_member
    if @member.update_attributes params[:member]
      flash[:notice] = "Subscriptions successfully changed"
      redirect_to member_subscriptions_path
    else
      render :action => 'subscriptions'
    end
  end

  def privacy
    @member = current_member
  end

  def update_privacy
    @member = current_member
    if @member.update_attributes params[:member]
      flash[:notice] = "Privacy successfully changed"
      redirect_to member_privacy_path
    else
      render :action => 'subscriptions'
    end
  end
  
  def follow_toggle
    case params[:followable_type]
      when 'Survey' then @followable = Survey.find(params[:followable_id])
      when 'Chart' then @followable = Chart.find(params[:followable_id])
      when 'Member' then @followable = Member.find(params[:followable_id])
      when 'Petition' then @followable = Petition.find(params[:followable_id])
      else @followable = nil 
    end
    if @followable
      if current_member.may_follow?(@followable)
        flash[:alert] = 'You cannot follow yourself.'
      else 
        @following = current_member.follow_toggle!(@followable)
      end
      redirect_to params[:redirect_to_url]
    end
  end

  private

    def build_resource(*args)
      super
      if session[:omniauth]
        @member.apply_omniauth(session[:omniauth], session[:omniauth_user_hash])
      end
      if session[:omniauth]
        @member.valid?
      end
    end

    def redirect_location(resource_name, resource)
      member_return_to
    end
end
