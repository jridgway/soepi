class ParticipantsController < ApplicationController
  prepend_before_filter :authenticate_member_2!, :except => [:index, :gmap, :by_city, :by_categories, :by_anonymous_key, :show, :show_responses]
  before_filter :load_default_facets, :except => [:by_facets]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
  caches_action :index, :gmap, :by_categories, :show, :show_responses, 
    :cache_path => Proc.new {|controller| controller.params}, 
    :expires_in => 1.hour
   
  def index
    render :layout => 'two_column'
  end
  
  def gmap
    @participants = Participant.group('lat, lng, city, state, postal_code, country').
      select('count(*) as total, lat, lng, city, state, postal_code, country')
  end
  
  def by_city
    @participant = Participant.new params[:participant]
    where_statement = {}
    where_statement[:city] = @participant.city unless @participant.city.blank?
    where_statement[:state] = @participant.state unless @participant.state.blank?
    where_statement[:postal_code] = @participant.postal_code unless @participant.postal_code.blank?
    where_statement[:country] = @participant.country unless @participant.country.blank?
    @participants = Participant.where(where_statement).page(params[:page]) unless where_statement.blank?
    render :layout => 'two_column'
  end
  
  def by_categories
    @facets = Participant.search do 
      [:gender, :age_group, :races, :ethnicities, :education].each do |f|
        with f, params[f] unless params[f].blank?
      end
      facet :gender, :age_group, :races, :ethnicities, :education
      paginate :page => params[:page], :per_page => 10
    end
    render :layout => 'two_column'
  end
  
  def by_anonymous_key
    if params[:participant] and params[:participant][:anonymous_key] and 
    (@participant = Participant.find_by_anonymous_key(params[:participant][:anonymous_key]))  
      redirect_to participant_path(@participant)
    else
      @participant = Participant.new params[:participant]
      @participant.errors.add :anonymous_key, 'not found' if params[:participant]
      render :layout => 'two_column'
    end
  end
  
  def show
    @participant = Participant.find params[:id]
    render :layout => 'two_column'
  rescue 
    error_404
  end
  
  def show_responses
    @participant = Participant.find params[:id]
    @survey_taken = @participant.surveys.find params[:survey_taken_id]
  rescue 
    error_404
  end
  
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
          redirect_to member_edit_participant_path
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
          redirect_to member_edit_participant_path
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
      redirect_to member_enter_your_pin_participant_path
    end
  end
  
  def update
    if current_participant
      if current_participant.update_attributes(params[:participant])
          flash[:alert] = "Your participant record was successfully updated.".html_safe
        redirect_to member_edit_participant_path
      else
        @participant = current_participant
        render :action => 'edit'
      end
    else
      redirect_to member_enter_your_pin_participant_path
    end
  end

  def enter_your_pin
    @member = current_member
  end

  def store_pin
    current_member.pin = params[:member][:pin]
    if @participant = Participant.find_by_member(current_member)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      redirect_to member_edit_participant_path
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
    
    def load_default_facets
      @facets = Participant.search do 
        facet :gender, :age_group, :races, :ethnicities, :education
      end
    end
end
