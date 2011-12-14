class SurveyQuestionsController < ApplicationController
  before_filter :authenticate_member!, :except => [:index]
  before_filter :load_survey
  before_filter :validate_editable, :only => [:new, :create, :edit, :update, :destroy]
  layout Proc.new {|controller| controller.request.xhr? ? 'ajax' : 'two_column'}

  def index
    @questions = @survey.questions.roots.all
    @question = @survey.questions.new params[:survey_question]
    @facebook_meta = {
      :url => survey_url(@survey),
      :title => @survey.title,
      :description => @survey.description,
      :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
      :type => 'Survey'
    }
  end

  def show
    @question = @survey.questions.find(params[:id])
    @participant_response = ParticipantResponse.new
  end
  
  def new 
    @question = @survey.questions.build params[:survey_question]
  end

  def create
    @question = @survey.questions.new params[:survey_question]
    if @question.save
      @question_just_added = @question
      @question = @survey.questions.build params[:survey_question]
      @question.body = '' 
    end
  end

  def edit
    @question = @survey.questions.find(params[:id])
  end

  def update
    @question = @survey.questions.find(params[:id])
    @choice_changed = (@question.survey_question_choice_id.to_i != params[:survey_question][:survey_question_choice_id].to_i)
    if @question.update_attributes params[:survey_question]
      @question.reload
    end
    @participant_response = ParticipantResponse.new
  end

  def update_positions
    @survey.update_question_positions! params[:survey_question]
    render :nothing => true
  end

  def destroy
    @question = @survey.questions.find(params[:id])
    @question.destroy
  end

  def survey_question_choice_id_options
    render :layout => false
  end

  protected

    def load_survey
      @survey = Survey.find params[:survey_id]
      unless @survey.published? or (member_signed_in? and (current_member.admin? or current_member.id == @survey.member_id))
        flash[:notice] = 'You cannot view the questions of this survey until it has been published.'
        redirect_to survey_path(@survey)
        false
      end
    end
    
    def validate_editable
      unless @survey.editable?
        if request.xhr?
          render :text => "alert('You cannot edit this survey.')"
        else
          flash[:alert] = 'You cannot edit this survey.'
          redirect_to survey_questions_path(:survey_id => @survey)
        end
        false
      end
    end
end
