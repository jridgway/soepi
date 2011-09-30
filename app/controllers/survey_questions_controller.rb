class SurveyQuestionsController < ApplicationController
  before_filter :authenticate_member!, :find_survey
  layout Proc.new {|controller| controller.request.xhr? ? 'ajax' : 'two_column_wide'}

  def index
    @questions = @survey.questions.roots.all
    @question = @survey.questions.new params[:survey_question]
    @facebook_meta = {
      :url => survey_url(@survey),
      :title => @survey.title,
      :description => @survey.description,
      :image_url => "#{request.protocol}#{request.host_with_port}/assets/logo-v13.png",
      :type => 'Survey'
    }
  end

  def show
    @question = @survey.questions.find(params[:id])
    @participant_response = ParticipantResponse.new
  end

  def create
    if @survey.editable?
      @question = @survey.questions.new params[:survey_question]
      @question.save
      @question_2 = SurveyQuestion.new params[:survey_question]
      @question_2.body = ''
    else
      flash[:alert] = 'You cannot edit this survey.'
      redirect_to survey_questions_path(:survey_id => @survey)
    end
  end

  def edit
    @question = @survey.questions.find(params[:id])
  end

  def update
    if @survey.editable?
      @question = @survey.questions.find(params[:id])
      @choice_changed = (@question.survey_question_choice_id.to_i != params[:survey_question][:survey_question_choice_id].to_i)
      if @question.update_attributes params[:survey_question]
        @question.reload
      end
      @participant_response = ParticipantResponse.new
    else
      flash[:alert] = 'You cannot edit this survey.'
      redirect_to survey_questions_path(:survey_id => @survey)
    end
  end

  def update_positions
    if @survey.editable?
      @survey.update_question_positions! params[:survey_question]
      render :nothing => true
    else
      flash[:alert] = 'You cannot edit this survey.'
      redirect_to survey_questions_path(:survey_id => @survey)
    end
  end

  def destroy
    if @survey.editable?
      @question = @survey.questions.find(params[:id])
      @question.destroy
    else
      flash[:alert] = 'You cannot edit this survey.'
      redirect_to survey_questions_path(:survey_id => @survey)
    end
  end

  def survey_question_choice_id_options
    render :layout => false
  end

  protected

    def find_survey
      if current_member.admin?
        @survey = Survey.find params[:survey_id]
      else
        @survey = current_member.surveys_posted.find params[:survey_id]
      end
    end
end
