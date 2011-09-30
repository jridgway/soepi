class ApplicationController < ActionController::Base
  protect_from_forgery
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'application' }
  before_filter :authenticate, :set_member_return_to, :force_no_cache_control
  helper_method :cache_expirary, :cache_expirary_in_seconds, :current_participant, :current_member_pin, :member_return_to,
    :avatar_url, :member_contact_us_path,  :message_members_path

  protected
  
  def authenticate
    #authenticate_or_request_with_http_basic do |username, password|
    #  username == "admin" && password == "ilovedata"
    #end
  end

  def admin_only!
    if not member_signed_in? or not current_member.admin?
      flash[:alert] = 'Insufficient privileges.'
      redirect_to root_path
      false
    end
  end

  def current_participant
    unless @current_participant
      if member_signed_in? and current_member_pin
        unless @current_participant
          current_member.pin = current_member_pin
          @current_participant = Participant.find_by_member current_member
        end
      end
    end
    @current_participant
  end

  def current_member_pin
    cookies.encrypted["pin_#{current_member.id}"] if current_member
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Member) or resource == :member
      member_return_to
    else
      super
    end
  end

  def after_sign_out_path_for(resource)    
    if resource.is_a?(Member) or resource == :member
      member_return_to
    else
      super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    if resource.is_a?(Member) or resource == :member
      member_return_to
    else
      super
    end
  end

  def after_update_path_for(resource)
    if resource.is_a?(Member) or resource == :member
      member_return_to
    else
      super
    end
  end

  def redirect_location(resource_name, resource)
    member_return_to
  end

  def set_member_return_to
    unless params[:member_return_to].blank?
      session[:member_return_to] = params[:member_return_to]
    end
    @member_return_to = session[:member_return_to]
  end

  def member_return_to
    @member_return_to || session[:member_return_to] || '/'
  end

  def cache_expirary
    15.minutes.from_now
  end

  def cache_expirary_in_seconds
    15.minutes.to_i
  end

  def set_cache_control
    if Rails.env.production? and not user_signed_in?
      response.headers['Cache-Control'] = "public, max-age=#{cache_expirary_in_seconds}"
    else
      force_no_cache_control
    end
  end

  def force_no_cache_control
    if Rails.env.production?
      response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    end
  end

  def avatar_url(member, size=100)
    if member.pic.nil?
      GravatarImageTag.gravatar_url(member.email_for_gravatar, 
        :alt => member.nickname, :width => size, :height => size, :gravatar => {:size => size})
    else
      member.pic.thumb("#{size}x#{size}").url
    end
  end
  
  def member_contact_us_path
    admins = Member.admins.collect(&:nickname).join('-')
    new_message_path(:members => admins)
  end
  
  def message_members_path(members)
    members = [members] unless members.is_a? Array
    nicknames = members.collect(&:nickname).join('-')
    new_message_path(:members => nicknames)
  end
end
