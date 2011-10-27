class PagesController < ApplicationController
  def home
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page]).per(20)
      @surveys = current_member.surveys_posted
      @follows = current_member.follows
      @followers = current_member.member_followers
      render :layout => 'two_column_wide'
    end
  end

  def show
  end
end
