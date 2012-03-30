class SurveysController < ApplicationController
  before_filter :load_survey, :except => [:new, :create, :add_target_survey, 
    :index, :drafting, :review_requested, :rejected, :launched, :published, :by_tag]
  
  before_filter :authenticate_member_2!, :except => [:index, :launched, :published, :by_tag, 
    :show, :edit, :forks, :followed_by, :demographics, :downloads, :reports, :collaborators]
  before_filter :admin_only!, :only => [:drafting, :review_requested, :rejected, :launch, :reject, :request_changes]
  before_filter :owner_only!, :only => [:submit_for_review, :destroy, :close]
  before_filter :owner_or_collaborators_only!, :only => [:update, :revert_to_version, :versions, :compare_versions]
  before_filter :owner_or_collaborators_only_until_published!, :only => [:collaborators, :edit, :forks, :followed_by, 
    :demographics, :downloads, :reports, :forkit]
  before_filter :load_open_graph_meta, :only => [:show, :versions, :forks, :forkit, :launch, :reject, :participate,
    :create_response, :update_pin, :generate_and_send_new_pin, :followed_by, :collaborators]
  before_filter :load_tags, :only => [:index, :by_tag]
  
  caches_action :index, :drafting, :rejected, :review_requested, :launched, :published, :by_tag, :show, :edit, 
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}, 
    :expires_in => 2.hours
  cache_sweeper :surveys_sweeper, :only => [:create, :update, :destroy, :submit_for_review, :request_changes, 
    :launch, :reject, :close]

  def index
    @surveys = Survey.live.page(params[:page])
    render :layout => 'two_column'
  end

  def launched
    @surveys = Survey.launched.page(params[:page])
    render :action => 'index', :layout => 'one_column'
  end

  def published
    @surveys = Survey.published.page(params[:page])
    render :action => 'index', :layout => 'one_column'
  end

  def drafting
    @surveys = Survey.drafting.page(params[:page])
    render :action => 'index', :layout => 'one_column'
  end

  def review_requested
    @surveys = Survey.review_requested.page(params[:page])
    render :action => 'index', :layout => 'one_column'
  end

  def rejected
    @surveys = Survey.rejected.page(params[:page])
    render :action => 'index', :layout => 'one_column'
  end

  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @surveys = Survey.tagged_with(@tag).live.page(params[:page])
    render :action => 'index'
  end

  def show
    render :layout => 'one_column'
  end

  def forks
    @forks = @survey.forks.closed_or_published.page(params[:page])
    render :layout => 'two_column'
  end
  
  def downloads
    @downloads = @survey.downloads.page(params[:page])
    render :layout => 'one_column'
  end

  def reports
    @reports = @survey.reports.page(params[:page])
    render :layout => 'one_column'
  end

  def followed_by
    @followings = @survey.member_followers.page(params[:page])
    render :layout => 'one_column'
  end

  def new
    @survey = current_member.surveys.new params[:survey]
    @survey.target = Target.new
    render :layout => 'one_column'
  end

  def create
    @survey = current_member.surveys.new params[:survey]
    if @survey.save
      @survey.version!(current_member.id)
      flash[:notice] = 'Your survey has been saved. You can add questions now, or come back later when you are ready.'
      redirect_to survey_questions_path(@survey)
    else
      render :action => 'new', :layout => 'one_column'
    end
  end

  def edit
    @survey.target ||= Target.new
    render :layout => 'one_column'
  end

  def update
    if @survey.may_edit?(current_member)
      if @survey.update_attributes params[:survey]
        @survey.version!(current_member.id)
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
    if @survey.may_edit?(current_member)
      @survey.destroy
      flash[:alert] = 'Your survey was deleted.'
      redirect_to root_path
    else
      flash[:alert] = 'You cannot delete this survey.'
      redirect_to_back_or(survey_path(@survey))
    end
  end
  
  def versions
    @versions = @survey.versions.page(params[:page])
  end
  
  def compare_versions
    @version_a = @survey.versions.find(params[:version_a_id])
    @versions = @survey.versions.where('id != ?', @version_a.id)
    if params[:version_b] and params[:version_b][:id].to_i > 0
      @version_b = @survey.versions.find(params[:version_b][:id]) 
    else 
      @version_b = @versions.first 
    end
  end
  
  def revert_to_version
    if @survey.drafting?
      @version = @survey.versions.find(params[:version_id]) 
      @survey.revert_to_version!(params[:version_id], current_member)
      flash[:notice] = "You have reverted this survey to version #{@version.position}."
    else
      flash[:notice] = "You cannot edit this survey."
    end
    redirect_to versions_survey_path(@survey)
  end
  
  def collaborators
    @collaborators = @survey.collaborators.page(params[:page])
    if member_signed_in? and (current_member.admin? or current_member.owner?(@survey)) 
      render :layout => 'two_column'
    else
      render :layout => 'one_column'
    end
  end
  
  def find_and_add_target_survey
    @keywords = params[:keywords]
    @results = Survey.search do 
      keywords params[:keywords]
      with :published, true
      paginate :page => params[:page], :per_page => 10
    end
  end
  
  def add_target_survey
    @survey = Survey.find params[:survey_id]
  end

  def submit_for_review
    if @survey.questions.empty?
      flash[:alert] = 'You must add at least one question before launching your survey. ' +
        'Your survey has not been submitted for review. '
      redirect_to survey_questions_path(:survey_id => @survey)
    elsif @survey.request_review!
      flash[:alert] = 'Your survey has been submitted for review. We will get back to you shortly. ' +
        'Please contact us if you have questions or concerns.'
      redirect_to_back_or(survey_path(@survey))
    else
      flash[:alert] = 'Your survey has not been submitted for review. ' +
        'Please contact us if you have questions or concerns.'
      redirect_to_back_or(survey_path(@survey))
    end
  end

  def request_changes
    @survey.changes_requested_by = current_member
    if @survey.request_changes!
      flash[:alert] = 'The status of the survey is now Drafting, and the member has been notified.'
    else
      flash[:alert] = 'Changes to the survey have NOT been requested.'
    end
    redirect_to_back_or(survey_path(@survey))
  end

  def reject
    if @survey.reject!
      flash[:alert] = 'The survey was rejected.'
    else
      flash[:alert] = 'The survey was NOT rejected.'
    end
    redirect_to_back_or(survey_path(@survey))
  end

  def launch
    if @survey.member_id == current_member.id
      flash[:alert] = 'You may not launch your own survey.'
    elsif @survey.launch!
      flash[:alert] = 'The survey has launched!'
    else
      flash[:alert] = 'The survey has NOT launched.'
    end
    redirect_to_back_or(survey_path(@survey))
  end

  def close
    if @survey.close! 
      flash[:alert] = "Your survey was closed. Please see the Questions, Demographics and Downloads pages for the results."
    else
      flash[:alert] = 'The survey was NOT closed.'
    end
    redirect_to_back_or(survey_path(@survey))
  end

  def forkit
    new_survey = @survey.forkit!(current_member.id)
    flash[:alert] = %{You forked survey, #{@survey.title}. You now have your own copy of the survey.
      You can make any edits you wish before launching it. For the sake of not revealing the questions and purpose
      of your new survey, it will not appear as a fork until you close and publish it.}
    redirect_to survey_path(new_survey)
  end

  def participate
    if request.put?
      if @survey.launched? and current_participant
        if current_member.id != @survey.member_id
          if current_participant.qualifies_for_survey?(@survey)
            unless current_participant.has_taken_survey?(@survey.id)
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
          render :text => "alert('You cannot participate in your own survey.');"
        end
      end
    else
      redirect_to_back_or(survey_path(@survey))
    end
  end

  def create_response
    if request.post? and current_participant
      if find_or_create_participant_survey(@survey)
        @participant_response = current_participant.responses.build(params[:participant_response])  
        @participant_response.participant_survey = @participant_survey
        if @participant_response.save
          if @question = @participant_survey.next_question
            @participant_response = current_participant.responses.build :question_id => @question.id
          end
        else
          @question = @participant_response.question
        end
        render :action => 'participate'
      end
    else
      render :text => "window.onbeforeunload = null; alert('An error occurred. Please refresh this page and try again.');"
    end
  end

  def store_pin
    current_member.pin = params[:member][:pin]
    if @current_participant = Participant.find_by_member(current_member)
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      unless current_participant.has_taken_survey?(@survey.id)
        if @question = find_or_create_participant_survey(@survey.id).next_question
          @participant_response = current_participant.responses.build :question_id => @question.id
        end
      end
    else
      current_member.errors.add :pin, 'Invalid PIN. Please try again.'
    end
    render :action => 'participate'
  end
  
  def new_participant
    @participant = Participant.new
  end

  def create_participant
    current_member.pin = params[:participant][:pin]
    if @participant = Participant.find_by_member(current_member)
      @participant.attributes = params[:participant].except(:pin)
    else
      @participant = Participant.new params[:participant]
    end
    @participant.member = current_member
    if @participant.save
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin     
      @current_participant = @participant
      unless current_participant.has_taken_survey?(@survey)
        if @question = find_or_create_participant_survey(@survey.id).next_question
          @participant_response = current_participant.responses.build :question_id => @question.id
        end
      end
      render :action => 'participate'
    else
      render :action => 'new_participant'
    end
  end

  protected

    def load_survey
      @survey = @followable = Survey.find(params[:id])
    rescue 
      error_404
      false
    end

    def load_open_graph_meta
      @open_graph_meta = {
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
        unless @participant_survey = current_participant.surveys.find_by_survey_id(survey_id)
          @participant_survey = current_participant.surveys.build :survey_id => survey_id
          @participant_survey.set_next_question
          @participant_survey.apply_participant
          @participant_survey.save!
        end
      end
      @participant_survey
    end

    def load_tags
      @tags = Survey.live.tag_counts :start_at => 2.months.ago, :limit => 100
    end
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:surveys_cache_expirary_key)
    end
  
    def owner_only!
      if not member_signed_in? or not (current_member.admin? or current_member.id == @survey.member_id)
        flash[:alert] = 'Insufficient privileges.'
        redirect_to survey_path(@survey)
        false
      end
    end
  
    def owner_or_collaborators_only!
      if not member_signed_in? or 
      not (current_member.admin? or current_member.owner?(@survey) or current_member.collaborator?(@survey))
        flash[:alert] = 'Insufficient privileges.'
        redirect_to survey_path(@survey)
        false
      end
    end
    
    def owner_or_collaborators_only_until_published!
      unless @survey.published? or @survey.closed?
        if not member_signed_in? or 
        not (current_member.admin? or current_member.owner?(@survey) or current_member.collaborator?(@survey))
          flash[:alert] = 'Insufficient privileges.'
          redirect_to survey_path(@survey)
          false
        end
      end
    end
end
