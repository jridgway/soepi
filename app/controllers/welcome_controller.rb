class WelcomeController < ApplicationController
  caches_action :subscribe, :expires_in => 2.hours

  def index
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page])
      if request.xhr?
        render :action => 'notifications'
      else
        @status = current_member.statuses.build
        load_default_tags
        render :layout => 'two_column'   
      end
    else
      render :layout => 'blank'
    end
  end
  
  def statuses
    @statuses = current_member.statuses.page(params[:page])
  end
  
  def surveys
    @surveys = current_member.surveys_owned_and_collaborating.page(params[:page])
  end
  
  def reports
    @reports = current_member.reports_owned_and_collaborating.page(params[:page])
  end
  
  def follows
    @follows = current_member.follows.page(params[:page])
  end
  
  def member_followers
    @member_followers = current_member.member_followers.page(params[:page])
  end
  
  def subscribe
    @page = Refinery::Page.find_by_slug('subscribe')
    if request.post? and params[:subscriber] and not params[:subscriber][:email].blank?
      h = Hominid::API.new(ENV['SOEPI_MAILCHIMP_KEY'], {:secure => true, :timeout => 60})
      if params[:subscriber][:unsubscribe] == '1'
        begin
          h.list_unsubscribe(Refinery::Setting.find_or_set('mailchimp_newsletter_list_id', '8d5bc6cad8'), params[:subscriber][:email], true, true, true)
        rescue 
        end
        flash[:notice] = "Sorry, we removed you from our list."
      else
        h.list_subscribe(Refinery::Setting.find_or_set('mailchimp_newsletter_list_id', '8d5bc6cad8'), params[:subscriber][:email], 
          {'FNAME' => params[:subscriber][:first_name], 'LNAME' => params[:subscriber][:last_name]}, 'html', false, true, true)
        flash[:notice] = "Yay, we added you to our list!"
      end
      redirect_to_back_or(root_path)
    else
      render :layout => 'one_column'
    end
  end
end
