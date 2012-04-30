class SurveyQuestionsController < ApplicationController
  before_filter :authenticate_member_2!, :except => [:index, :results]
  before_filter :load_survey
  before_filter :may_access?, :only => [:index]
  before_filter :load_question, :except => [:new, :create, :index, :update_positions]
  before_filter :owner_or_collaborators_only_until_published!
  before_filter :authorize_edit!, :only => [:new, :create, :edit, :update, :destroy]
  layout Proc.new {|controller| controller.request.xhr? ? 'ajax' : 'two_column'}
  
  caches_action :index, :expires_in => 2.hours

  def index
    if (member_signed_in? and @survey.may_access?(current_member)) or @survey.closed? or @survey.published?
      @questions = @survey.questions.roots.includes(:choices => [:child_questions]).all
      @question = @survey.questions.new params[:survey_question]
      @open_graph_meta = {
        :url => survey_url(@survey),
        :title => @survey.title,
        :description => @survey.description,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'Survey'
      }
    else
      redirect_to survey_path(@survey)
    end
  end

  def show
    @participant_response = ParticipantResponse.new
  end
  
  def new 
    @question = @survey.questions.build params[:survey_question]
  end

  def create
    if ['Yes/No', 'True/False'].include? params[:survey_question][:qtype]
      @question = @survey.questions.new params[:survey_question].except(:choices_attributes)
    else
      @question = @survey.questions.new params[:survey_question]
    end
    if @question.save
      @survey.version!(current_member.id)
      @question_just_added = @question
      @question = @survey.questions.build params[:survey_question]
      @question.body = '' 
      @question.label = '' 
      expire_action :action => :index
    end
  end

  def edit
  end

  def update
    if @question.update_attributes params[:survey_question]
      @survey.version!(current_member.id)
      @question.reload
      expire_action :action => :index
    end
    @participant_response = ParticipantResponse.new
  end

  def update_positions
    if @survey.may_edit?(current_member)
      @survey.update_question_positions! params[:survey_question]
      expire_action :action => :index
      render :nothing => true
    else
      render :text => "alert('You cannot edit this survey.');"
    end
  end

  def destroy
    @survey.version!(current_member.id)
    @question.destroy
    expire_action :action => :index
  end
  
  def results
  end

  protected

    def load_survey
      @survey = Survey.find params[:survey_id]
    end

    def load_question
      @question = @survey.questions.find params[:id]
    end
    
    def owner_or_collaborators_only_until_published!
      if not (@survey.published? or @survey.closed?) and 
      member_signed_in? and not (current_member.admin? or current_member.id == @survey.member_id or 
      @survey.collaborators.collect(&:member_id).include?(current_member.id))
        redirect_to survey_path(@survey)
        false
      end
    end
    
    def authorize_edit!
      unless @survey.may_edit?(current_member)
        if request.xhr?
          render :text => "alert('You cannot edit this survey.')"
        else
          redirect_to survey_questions_path(:survey_id => @survey)
        end
        false
      end
    end
    
    def may_access?
      unless (member_signed_in? and @survey.may_access?(current_member)) or @survey.closed? or @survey.published?
        redirect_to survey_path(@survey)
      end
    end
end
