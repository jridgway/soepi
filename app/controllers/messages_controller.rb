class MessagesController < ApplicationController
  before_filter :authenticate_member_2!
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }

  def index
    @messages = Message.involving_member(current_member.id).roots.recent.page(params[:page])
  end

  def unread
    @messages = Message.involving_member_unseen(current_member.id).recent.page(params[:page])
    render :action => 'index'
  end
  
  def new 
    @message = current_member.messages.build params[:message]
    @message.recipient_nicknames = params[:members].split('-').join(', ') unless params[:members].blank?
  end

  def create
    @message = current_member.messages.build params[:message]
    if @message.save 
      unless request.xhr?
        redirect_to message_path(@message)
      end
    else
      unless request.xhr?
        render :action => 'new'
      end
    end
  end
  
  def show
    @message = Message.find params[:id]
    if @message.member_id == current_member.id or @message.members.collect(&:id).include?(current_member.id)
      if @message.parent_message
        redirect_to message_path(@message.parent_message)
      else
        @new_message = current_member.messages.build params[:message]
        @new_message.message_id = @message.id
        @message.mark_seen_by_member!(current_member.id)
        render :layout => 'two_column'
      end
    else
      error_404
    end
  end
end
