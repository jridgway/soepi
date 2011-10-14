class Members::AccountsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :except => [:new, :create, :load_current_member]
  layout Proc.new { |controller| 
    %w{new create}.include?(controller.action_name) ? 'two_column' : (controller.request.xhr? ? 'ajax' : 'one_column')
  }

  def create
    super
    unless @member.new_record?
      set_pin_cookie_helper(@member.pin)
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

  def your_pin
    @member = current_member
    @member.pin = current_member_pin
  end

  def update_pin
    current_member.pin = params[:member][:pin]
    if Participant.find_by_member current_member
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      redirect_to member_your_pin_path
    else
      @member = current_member
      current_member.errors.add :pin, 'Invalid PIN. Please try again.'
      render :action => 'your_pin'
    end
  end

  def generate_and_send_new_pin
    current_member.generate_and_deliver_pin!
    set_pin_cookie_helper(current_member.pin)
    flash[:alert] = nil
    redirect_to member_your_pin_path
  end

  def load_current_member
    if member_signed_in?
      unless params[:followable_id].blank? or params[:followable_type].blank?
        case params[:followable_type]
          when 'Survey' then @followable = Survey.find(params[:followable_id])
          when 'Chart' then @followable = Chart.find(params[:followable_id])
          when 'Member' then @followable = Member.find(params[:followable_id])
          when 'Forum' then @followable = Forum.find(params[:followable_id])
          when 'Petition' then @followable = Petition.find(params[:followable_id])
          else @followable = nil 
        end
      end
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
      if (@followable.is_a?(Member) and @followable.id == current_member.id) or 
      (not @followable.is_a?(Member) and @followable.member_id == current_member.id)
        if request.xhr?
          render :text => "alert('You cannot follow yourself.'); enable_button($('#follow-toggle'));"
        else
          flash[:alert] = 'You cannot follow yourself.'
        end
      else 
        if current_member.following?(@followable)
          current_member.stop_following(@followable)
          @following = false
        else
          current_member.follow(@followable)
          @following = true
        end
      end
      unless request.xhr?
        case params[:followable_type]
          when 'Survey' then redirect_to survey_path(@followable)
          when 'Chart' then redirect_to chart_path(@followable)
          when 'Member' then redirect_to member_path(@followable)
          when 'Petition' then redirect_to petition_path(@followable)
        end
      end
    end
  end

  protected

    def set_pin_cookie_helper(pin)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = pin
      flash[:alert] = "<h2>Your PIN is: #{pin}</h2><p>Don't forget it! We highly suggest you store it on your computer or write it down.</p>".html_safe
    end

    def redirect_location(resource_name, resource)
      member_return_to
    end

  private

    def build_resource(*args)
      super
      @member.language ||= I18n.locale
      if session[:omniauth]
        @member.apply_omniauth(session[:omniauth], session[:omniauth_user_hash])
      end
      if session[:omniauth]
        @member.valid?
      end
    end
end
