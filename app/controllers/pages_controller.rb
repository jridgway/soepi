class PagesController < ApplicationController
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'two_column_wide' }
  
  def home
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page]).per(20)
      @surveys = current_member.surveys
      @r_scripts = current_member.r_scripts
      @reports = current_member.reports
      @follows = current_member.follows
      @followers = current_member.member_followers
      tag_limit = 50
    else
      tag_limit = 5
    end
    @slides = Slide.live
    @tags = (Survey.live.tag_counts(:start_at => 2.months.ago, :limit => tag_limit) +
      Member.confirmed.tag_counts(:start_at => 2.months.ago, :limit => tag_limit)).sort {|a,b| a.count <=> b.count}.sort {|a,b| a.name <=> b.name}
  end
  
  def notifications
    notifications = current_member.notifications.page(params[:page]).per(20)
    render :partial => 'notifications', :locals => {:notifications => notifications}
  end

  def show
  end
end
