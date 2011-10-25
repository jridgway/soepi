class SurveysController < ApplicationController
  before_filter :load_survey, :only => [:show, :forks, :results, :forkit, :launch, :reject, :request_changes, 
    :participate, :create_response, :update_pin, :generate_and_send_new_pin, :followed_by]
  before_filter :load_facebook_meta, :only => [:show, :forks, :results, :forkit, :launch, :reject, :participate,
    :create_response, :update_pin, :generate_and_send_new_pin, :followed_by]
  before_filter :authenticate_member!, :except => [:index, :launched, :closed, :published, :show, :forks, :sharing, 
    :by_tag, :followed_by, :results]
  before_filter :admin_only!, :only => [:drafting, :review_requested, :rejected, :launch, :reject, :request_changes]
  before_filter :load_tags, :only => [:index, :recent, :you_created, :by_tag]
  
  enable_esi
  
  caches_action :index, :drafting, :rejected, :you_created, :by_tag, :show, :edit, 
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}
  cache_sweeper :surveys_sweeper, :only => [:create, :update, :destroy, :submit_for_review, :request_changes, 
    :launch, :reject, :close]

  def index
    @surveys = Survey.live.page(params[:page]).per(10)
    render :layout => 'two_column'
  end

  def launched
    @surveys = Survey.launched.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def closed
    @surveys = Survey.closed.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def published
    @surveys = Survey.published.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def drafting
    @surveys = Survey.drafting.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def review_requested
    @surveys = Survey.review_requested.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def rejected
    @surveys = Survey.rejected.page(params[:page]).per(10)
    render :action => 'index', :layout => 'one_column'
  end

  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @surveys = Survey.tagged_with(@tag).live.page(params[:page]).per(10)
    render :action => 'index'
  end

  def show
    render :layout => 'one_column'
  end

  def new
    @survey = current_member.surveys_posted.new params[:survey]
    @survey.target = Target.new
    render :layout => 'one_column'
  end

  def create
    @survey = current_member.surveys_posted.new params[:survey]
    if @survey.save
      redirect_to survey_questions_path(@survey)
    else
      render :action => 'new', :layout => 'one_column'
    end
  end

  def edit
    if current_member.admin?
      @survey = Survey.find params[:id]
    else
      @survey = current_member.surveys_posted.find params[:id]
    end
    @survey.target ||= Target.new
    render :layout => 'one_column'
  end

  def update
    @survey = current_member.surveys_posted.find params[:id]
    if @survey.editable?
      if @survey.update_attributes params[:survey]
        flash[:alert] = 'Your survey was successfully updated.'
        redirect_to edit_survey_path(@survey)
      else
        render :action => 'edit',  :layout => 'one_column'
      end
    else
      flash[:alert] = 'You cannot edit this survey.'
      render :action => 'edit',  :layout => 'one_column'
    end
  end

  def destroy
    @survey = current_member.surveys_posted.find params[:id]
    if @survey.editable?
      @survey.destroy
      flash[:alert] = 'Your survey was deleted.'
      redirect_to root_path
    else
      flash[:alert] = 'You cannot delete this survey.'
      redirect_to survey_path(@survey)
    end
  end

  def submit_for_review
    @survey = current_member.surveys_posted.find params[:id]
    if @survey.questions.empty?
      flash[:alert] = 'You must add at least one question before launching your survey. ' +
        'Your survey has not been submitted for review. '
      redirect_to survey_questions_path(:survey_id => @survey)
    elsif @survey.request_review!
      flash[:alert] = 'Your survey has been submitted for review. We will get back to you shortly. ' +
        'Please contact us if you have questions or concerns.'
      redirect_to survey_path(@survey)
    else
      flash[:alert] = 'Your survey has not been submitted for review. ' +
        'Please contact us if you have questions or concerns.'
      redirect_to survey_path(@survey)
    end
  end

  def launch
    if @survey.member_id == current_member.id
      flash[:alert] = 'You may not launch your own survey.'
    elsif @survey.launch!
      flash[:alert] = 'The survey has launched!'
    else
      flash[:alert] = 'The survey has NOT launched.'
    end
    redirect_to survey_path(@survey)
  end

  def request_changes
    if @survey.request_changes!
      flash[:alert] = 'The status of the survey is now "Changes Requested." Please compose a message to the member describing your requests.'
      redirect_to new_message_path(:members => @survey.member.nickname)
    else
      flash[:alert] = 'Changes to the survey have NOT been requested.'
      redirect_to survey_path(@survey)
    end
  end

  def reject
    if @survey.reject!
      flash[:alert] = 'The survey was rejected.'
    else
      flash[:alert] = 'The survey was NOT rejected.'
    end
    redirect_to survey_path(@survey)
  end

  def participate
    if request.put?
      if @survey.launched? and current_participant
        if current_member.id != @survey.member_id
          if current_member.qualifies_for_survey?(@survey)
            unless current_member_not_participant_has_taken_survey(@survey)
              if find_or_create_participant_survey(@survey.id)
                if @question = @participant_survey.next_question
                  @participant_response = current_participant.responses.build :question_id => @question.id
                end
              end
            end
          else
            render :text => "alert('We are sorry, you do not qualify for this survey.'); enable_button($('#participate')); enable_button($('#participate2'));"
          end
        else
          render :text => "alert('You cannot participate in your own survey.');'));"
        end
      end
    else
      redirect_to survey_path(@survey)
    end
  end

  def create_response
    if request.post? and current_participant
      @participant_response = current_participant.responses.build(params[:participant_response])
      if @participant_response.save
        if find_or_create_participant_survey(@survey)
          if @question = @participant_survey.next_question
            @participant_response = current_participant.responses.build :question_id => @question.id
          end
        end
        render :action => 'participate'
      else
        @question = @participant_response.question
      end
    else
      render :text => "window.onbeforeunload = null; alert('An error occurred. Please refresh this page and try again.');"
    end
  end

  def update_pin
    current_member.pin = params[:member][:pin]
    if @current_participant = Participant.find_by_member(current_member)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      unless current_member_not_participant_has_taken_survey(@survey)
        if @question = find_or_create_participant_survey(@survey.id).next_question
          @participant_response = current_participant.responses.build :question_id => @question.id
        end
      end
    else
      current_member.errors.add :pin, 'Invalid PIN. Please try again.'
    end
    render :action => 'participate'
  end

  def generate_and_send_new_pin
    current_member.generate_and_deliver_pin!
    cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
    @current_participant = Participant.find_by_member(current_member)
    unless current_member_not_participant_has_taken_survey(@survey)
      if @question = find_or_create_participant_survey(@survey.id).next_question
        @participant_response = current_participant.responses.build :question_id => @question.id
      end
    end
    render :action => 'participate'
  end

  def close
    if current_member.admin?
      @survey = Survey.find params[:id]
    else
      @survey = current_member.surveys_posted.find params[:id]
    end
    if @survey.close!
      flash[:alert] = %{The survey was closed. In order to protect the privacy of
        the paricipants, the results will be published only after a full review by SoEpi. Please
        <a href="#{member_contact_us_path}">contact us</a> if
        you have questions or comments.}.html_safe
        #/
    else
      flash[:alert] = 'The survey was NOT closed.'
    end
    redirect_to survey_path(@survey)
  end

  def forkit
    new_survey = @survey.forkit!(current_member.id)
    flash[:alert] = %{You forked survey, #{@survey.title}. You now have your own copy of the survey.
      You can make any edits you wish before launching it.}
    redirect_to survey_path(new_survey)
  end

  def forks
    @forks = @survey.forks.live_or_drafting.page(params[:page])
    render :layout => 'one_column'
  end

  def results
    render :layout => 'one_column'
  end

  def followed_by
    @followings = @survey.followings.page(params[:page])
    render :layout => 'one_column'
  end

  protected

    def load_survey
      @survey = Survey.find(params[:id])
    end

    def load_facebook_meta
      @facebook_meta = {
        :url => survey_url(@survey),
        :title => @survey.title,
        :description => @survey.description,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'Survey'
      }
    end
    
    def validate_survey
      unless @survey.valid?
        render :action => 'edit',  :layout => 'one_column'
        false
      end
    end

    def find_or_create_participant_survey(survey_id)
      unless @participant_survey
        @participant_survey = current_participant.surveys.find_or_create_by_survey_id survey_id
        @participant_survey.apply_member current_member
        @participant_survey.save
        current_member.surveys_taken << @survey
      end
      @participant_survey
    end

    def current_member_not_participant_has_taken_survey(survey)
      true if current_participant.surveys.where(:survey_id => survey.id).count == 0 and
        current_member.surveys_taken.exists?(survey.id)
    end

    def load_tags
      @tags = Survey.live.tag_counts :start_at => 2.months.ago, :limit => 100
    end
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:surveys_cache_expirary_key)
    end
end
