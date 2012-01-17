class WelcomeController < ApplicationController
  def index
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page]).per(20)
      if request.xhr?
        render :action => 'notifications'
      else
        @status = current_member.statuses.build
        load_default_tags
        render :layout => 'two_column_wide'   
      end
    else
      render :layout => 'blank'
    end
  end
  
  def statuses
    @statuses = current_member.statuses.page(params[:page]).per(20)
  end
  
  def create_status
    @status = current_member.statuses.build params[:member_status]
    @status.save
  end
  
  def surveys
    @surveys = current_member.surveys.page(params[:page]).per(20)
  end
  
  def reports
    @reports = current_member.reports.page(params[:page]).per(20)
  end
  
  def follows
    @follows = current_member.follows.page(params[:page]).per(20)
  end
  
  def member_followers
    @member_followers = current_member.member_followers.page(params[:page]).per(20)
  end
  
  def subscribe
    if request.post? and params[:subscriber] and not params[:subscriber][:email].blank?
      h = Hominid::API.new(ENV['SOEPI_MAILCHIMP_KEY'], {:secure => true, :timeout => 60})
      if params[:subscriber][:unsubscribe] == '1'
        begin
          h.list_unsubscribe(Setting.find_or_set('mailchimp_newsletter_list_id', '8d5bc6cad8'), params[:subscriber][:email], true, true, true)
        rescue 
        end
        flash[:notice] = "Sorry, we removed you from our list."
      else
        h.list_subscribe(Setting.find_or_set('mailchimp_newsletter_list_id', '8d5bc6cad8'), params[:subscriber][:email], 
          {'FNAME' => params[:subscriber][:first_name], 'LNAME' => params[:subscriber][:last_name]}, 'html', false, true, true)
        flash[:notice] = "Yay, we added you to our list!"
      end
      redirect_to_back_or(root_path)
    else
      render :layout => 'two_column_wide'
    end
  end
end
