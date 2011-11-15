class ParticipantsController < ApplicationController
  before_filter :authenticate_member!
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  
  def new 
    if current_participant
      redirect_to :action => 'edit'
    else
      @participant = Participant.new 
    end
  end
  
  def create
    if current_participant
      redirect_to :action => 'edit'
    else
      current_member.pin = params[:participant][:pin]
      if @participant = Participant.find_by_member(current_member)
        if @participant.update_attributes params[:participant]
          set_pin_cookie_helper(current_member.pin)
          redirect_to edit_participant_path
        else
          cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
          @participant.pin = params[:participant][:pin]
          render :action => 'edit'
        end
      else
        @participant = Participant.new params[:participant]
        @participant.member = current_member
        if @participant.save
          set_pin_cookie_helper(@participant.pin)
          redirect_to edit_participant_path
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def edit
    if current_participant
      @participant = current_participant
    else
      redirect_to participant_enter_your_pin_path
    end
  end
  
  def update
    if current_participant
      if current_participant.update_attributes(params[:participant])
          flash[:alert] = "Your participant record was successfully updated.".html_safe
        redirect_to edit_participant_path
      else
        @participant = current_participant
        render :action => 'edit'
      end
    else
      redirect_to participant_enter_your_pin_path
    end
  end

  def enter_your_pin
    @member = current_member
  end

  def store_pin
    current_member.pin = params[:member][:pin]
    if @participant = Participant.find_by_member(current_member)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      redirect_to edit_participant_path
    else
      current_member.errors.add :pin, 'Invalid PIN. Please try again.'
      @member = current_member
      render :action => 'enter_your_pin'
    end
  end
  
  protected

    def set_pin_cookie_helper(pin)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = pin
      flash[:alert] = "<h2>Your PIN is: #{pin}</h2><p>Don't forget it! We highly suggest you store it on your computer or write it down.</p>".html_safe
    end
end
