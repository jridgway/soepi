class PagesController < ApplicationController
  def home
    if member_signed_in?
      @notifications = current_member.notifications.page(params[:page]).per(20)
    end
  end

  def show
  end
end
