class ApplicationController < ActionController::Base
  protect_from_forgery
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'two_column' }
  before_filter :set_member_return_to, :force_no_cache_control
  helper_method :cache_expirary, :cache_expirary_in_seconds, :current_participant, :current_member_pin, :member_return_to,
    :avatar_url, :member_contact_us_path,  :message_members_path
  enable_esi

  protected
    
    def authenticate_member_2!
      unless current_member
        flash[:notice] = t('devise.failure.unauthenticated')
        redirect_to main_app.new_member_session_path(:member_return_to => request.path)
        false
      end
    end
    
    def load_default_tags
      @tags = (
          Survey.live.tag_counts(:start_at => 6.months.ago, :limit => 50) +
          Report.tag_counts(:start_at => 6.months.ago, :limit => 50) +
          Member.tag_counts(:start_at => 6.months.ago, :limit => 50) +
          MemberStatus.tag_counts(:start_at => 6.months.ago, :limit => 50)
        )[0..49].sort {|a,b| a.count <=> b.count}.sort {|a,b| a.name <=> b.name}
    end
  
    def admin_only!
      if not member_signed_in? or not current_member.admin?
        flash[:alert] = 'Insufficient privileges.'
        redirect_to root_path
        false
      end
    end
  
    def current_participant
      if member_signed_in? and cookies.encrypted["pin_#{current_member.id}"]
        unless @current_participant
          current_member.pin = cookies.encrypted["pin_#{current_member.id}"]
          @current_participant = Participant.find_by_member current_member
        end
      end
      @current_participant
    end
  
    def current_member_pin
      cookies.encrypted["pin_#{current_member.id}"] if current_member and current_participant
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
        main_app.new_member_session_path(:member_return_to => member_return_to)
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
    
    def redirect_to_back_or(other)
      if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        redirect_to :back
      else
        redirect_to other
      end
    end
end
