class SurveysController < ApplicationController
  before_filter :load_survey, :except => [:find_and_add_target_survey, :add_target_survey,
    :new, :create, :add_target_survey, :index, :drafting, :review_requested, :rejected, :launched, :published, :by_tag]
  
  before_filter :authenticate_member_2!, :except => [:find_and_add_target_survey, :add_target_survey,
    :new, :create, :index, :launched, :published, :by_tag, 
    :show, :edit, :forks, :followed_by, :demographics, :downloads, :reports, :collaborators]
  before_filter :admin_only!, :only => [:drafting, :review_requested, :rejected, :launch, :reject, :request_changes]
  before_filter :owner_only!, :only => [:pilot, :stop_pilot, :submit_for_review, :destroy, :close]
  before_filter :owner_or_collaborators_only!, :only => [:update, :revert_to_version, :versions, :compare_versions]
  before_filter :owner_or_collaborators_only_until_published!, :only => [:collaborators, :edit, :forks, :followed_by, 
    :demographics, :downloads, :reports, :forkit]
  before_filter :load_open_graph_meta, :only => [:show, :versions, :forks, :forkit, :launch, :reject, :participate,
    :followed_by, :collaborators]
  before_filter :load_tags, :only => [:index, :by_tag]
  
  caches_action :index, :drafting, :rejected, :review_requested, :launched, :published, :by_tag, :show, 
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
    @surveys = Survey.drafting.not_by_visitor.page(params[:page])
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
    if member_signed_in?
      @survey = current_member.surveys.new params[:survey]
      @survey.target = Target.new
    else
      @survey = Survey.new params[:survey]
      @survey.target = Target.new
    end
    render :layout => 'one_column'
  end

  def create
    if member_signed_in?
      @survey = current_member.surveys.new params[:survey]
      if @survey.save
        @survey.version!(current_member.id)
        flash[:notice] = 'Your survey has been saved. You can add questions now, or come back later when you are ready.'
        redirect_to survey_questions_path(@survey)
      else
        render :action => 'new', :layout => 'one_column'
      end
    else
      @survey = Survey.new params[:survey]
      if @survey.save
        session[:survey_ids] ||= []
        session[:survey_ids] << @survey.id 
        session[:survey_ids] = session[:survey_ids][0..2] if session[:survey_ids].length > 3
        flash[:notice] = 'Your survey has been saved. Please sign up to continue.'
        redirect_to main_app.new_member_registration_path(:member_return_to => survey_questions_path(@survey))
      else
        render :action => 'new', :layout => 'one_column'
      end
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

  def pilot
    if @survey.pilot!
      flash[:alert] = ('Your pilot has begun, but is hidden from the public. ' +
        'You must share the following URL (the URL of this survey) with anyone that you want to participate in this pilot: <br/><br/>' +
        '<a href="' + survey_url(@survey) + '">' + survey_url(@survey) + '</a>').html_safe
      redirect_to survey_path(@survey)
    else
      flash[:alert] = 'Your pilot has not begun. Please contact us for help.'
      redirect_to_back_or survey_path(@survey)
    end
  end

  def stop_pilot
    if @survey.stop_pilot!
      flash[:alert] = 'Your pilot has stopped, the results were removed, and your survey is back in drafting mode. You may make changes and start another pilot, or launch your survey as is.'
      redirect_to survey_questions_path(@survey)
    else
      flash[:alert] = 'Your pilot was not stopped. Please contact us for help.'
      redirect_to_back_or survey_path(@survey)
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

    def load_tags
      @tags = Survey.live.tag_counts :start_at => 2.months.ago, :limit => 100
    end
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:surveys_cache_expirary_key)
    end
  
    def owner_only!
      if not member_signed_in? or not (current_member.admin? or current_member.id == @survey.member_id)
        redirect_to survey_path(@survey)
        false
      end
    end
  
    def owner_or_collaborators_only!
      if not member_signed_in? or 
      not (current_member.admin? or current_member.owner?(@survey) or current_member.collaborator?(@survey))
        redirect_to survey_path(@survey)
        false
      end
    end
    
    def owner_or_collaborators_only_until_published!
      unless @survey.published? or @survey.closed?
        if not member_signed_in? or 
        not (current_member.admin? or current_member.owner?(@survey) or current_member.collaborator?(@survey))
          redirect_to survey_path(@survey)
          false
        end
      end
    end
end
