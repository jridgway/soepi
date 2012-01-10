class WelcomeController < ApplicationController
  def index
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page]).per(20)
      if request.xhr?
        render :action => 'notifications'
      else
        @status = current_member.statuses.build
        @tags = (
            Survey.live.tag_counts(:start_at => 6.months.ago, :limit => 50) +
            Report.tag_counts(:start_at => 6.months.ago, :limit => 50) +
            Member.confirmed.tag_counts(:start_at => 6.months.ago, :limit => 50) +
            MemberStatus.tag_counts(:start_at => 6.months.ago, :limit => 50)
          )[0..49].sort {|a,b| a.count <=> b.count}.sort {|a,b| a.name <=> b.name}
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
end
