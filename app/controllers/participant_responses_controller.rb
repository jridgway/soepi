class ParticipantResponsesController < ApplicationController
  before_filter :authenticate_member_2!
  before_filter :load_survey
  before_filter :authorize!
  before_filter :check_max_piloters!
  before_filter :load_participant
  before_filter :require_participant!, :except => [:new_participant, :create_participant, :store_pin]
  before_filter :load_participant_survey
  before_filter :load_open_graph_meta

  def new
    if request.xhr?
      if @participant.tester?  
        @participant_survey.responses.destroy_all
        @participant_survey.update_attribute :complete, false
        @question = @survey.questions.find(params[:question_id])
        @participant_response = @participant.responses.build :question_id => @question.id
        create_parent_responses_for_tester_starting_in_the_middle(@question.parent_choice)
      else
        init_first_question
      end
    else
      redirect_to survey_path(@survey)
    end
  end
  
  def create_parent_responses_for_tester_starting_in_the_middle(parent_choice)
    if parent_choice
      if parent_choice.question.parent_choice
        create_parent_responses_for_tester_starting_in_the_middle(parent_choice.question.parent_choice) 
      end
      case parent_choice.question.qtype
        when 'Yes/No', 'True/False', 'Select One' then
          @participant.responses.create :question_id => parent_choice.question.id, :single_choice => parent_choice
        when 'Select Multiple' then
          @participant.responses.create :question_id => parent_choice.question.id, :multiple_choices => [parent_choice]
      end
    end
  end

  def create
    @participant_response = @participant.responses.build(params[:participant_response])  
    @participant_response.participant_survey = @participant_survey
    if @participant_response.save
      if @question = @participant_survey.next_question
        @participant_response = @participant.responses.build :question_id => @question.id
      end
    else
      @question = @participant_response.question
    end
    if @question.nil?
      render :action => 'thanks'
    end
  end

  def edit
    @participant_response = @participant.responses.find(params[:id])
    @question = @participant_response.question
    @participant_response.destroy_following_responses!
  end

  def update
    @participant.responses.destroy(params[:id])  
    @participant_response = @participant.responses.build(params[:participant_response])  
    @participant_response.participant_survey = @participant_survey
    if @participant_response.save
      if @question = @participant_survey.next_question
        @participant_response = @participant.responses.build :question_id => @question.id
      end
    else
      @question = @participant_response.question
    end
    if @question.nil?
      render :action => 'thanks'
    end
  end

  def destroy_all
    @participant_survey.destroy
  end

  def store_pin
    current_member.pin = params[:member][:pin]
    if @participant = Participant.find_by_member(current_member)
      @current_participant = @participant
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin
      load_participant_survey
      init_first_question
    else
      current_member.errors.add :pin, 'Invalid PIN. Please try again.'
      render :action => 'require_pin'
    end
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
      @current_participant = @participant
      cookies.permanent.encrypted["pin_#{current_member.id}"] = current_member.pin    
      load_participant_survey
      init_first_question
    else
      render :action => 'new_participant'
    end
  end

  protected

    def load_survey
      @survey = Survey.find(params[:survey_id])
    end

    def authorize!
      if @survey.drafting? 
        unless @survey.may_edit?(current_member)
          render :text => "alert('Sorry, only the owner and collaborators of this survey can preview it.');"
          false
        end
      elsif not @survey.launched? and not @survey.piloting?
        render :text => "alert('Sorry, this survey is not open for participation.');"
        false
      end
    end
    
    def check_max_piloters!
      if @survey.piloting? and not @survey.pilot_open?
        render :action => 'pilot_no_longer_open'
        false
      end
    end
    
    def load_participant
      if @survey.drafting? and @survey.may_edit?(current_member)
        if cookies.encrypted["survey_tester_id_#{current_member.id}"]
          unless @participant
            @participant = Participant.where('id = ? and tester = true', 
              cookies.encrypted["survey_tester_id_#{current_member.id}"]).first
          end
        else
          @participant = Participant.create :tester => true
          cookies.encrypted["survey_tester_id_#{current_member.id}"] = @participant.id
        end        
      else
        @participant = current_participant
      end
    end
    
    def require_participant!
      unless @participant
        render :action => 'require_pin'
        false
      end
    end
    
    def load_participant_survey
      if @participant
        unless @participant_survey
          @participant_survey = @participant.surveys.find_or_create_by_survey_id(@survey.id)
        end
      end
    end

    def find_or_create_participant_survey(survey_id)
      unless @participant_survey = @participant.surveys.find_by_survey_id(survey_id)
        @participant_survey = @participant.surveys.build :survey_id => survey_id
        @participant_survey.set_next_question
        @participant_survey.apply_participant
        @participant_survey.save!
      end
      puts @participant_survey.errors.to_yaml
      @participant_survey
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
    
    def init_first_question      
      if current_member.id != @survey.member_id
        if @participant.qualifies_for_survey?(@survey)
          if @participant.has_taken_survey?(@survey.id)
            render :action => 'thanks'
          else
            @question = @participant_survey.next_question
            @participant_response = @participant.responses.build :question_id => @question.id
            render :action => 'new'
          end
        else
          render :action => 'does_not_qualify'
        end
      else
        render :text => "alert('You cannot participate in your own survey.');"
      end
    end
end
