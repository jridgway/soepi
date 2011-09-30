class ParticipantResponsesController < ApplicationController
  before_filter :authenticate_member!, :find_survey

  def index
    @questions = @survey.questions.all
  end

  def show
    @question = @survey.questions.find(params[:id])
    @participant_response = ParticipantResponse.new
  end

  def create
    @question = @survey.questions.new params[:survey_question]
    @question.save
  end

  def update
    @question = @survey.questions.find(params[:id])
    @question.update_attributes params[:survey_question]
  end

  def destroy
    @question = @survey.questions.find(params[:id])
    @question.destroy
  end

  protected

    def find_survey
      @survey = Survey.live.find params[:survey_id]
    end
end
