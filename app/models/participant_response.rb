class ParticipantResponse < ActiveRecord::Base
  belongs_to :participant
  belongs_to :participant_survey
  has_and_belongs_to_many :multiple_choices, :class_name => 'SurveyQuestionChoice'
  belongs_to :single_choice, :class_name => 'SurveyQuestionChoice'
  belongs_to :question, :class_name => 'SurveyQuestion'

  validates_presence_of :participant, :question
  validates_uniqueness_of :question_id, :scope => :participant_id
  validates_numericality_of :numeric_response, :allow_blank => true, :only_integer => true
  validate :question_required
  after_create :set_next_question, :check_and_set_complete
  after_destroy :set_next_question, :check_and_set_complete

  def choices
    (multiple_choices + [single_choice]).compact
  end

  def question_required
    if question.required?
      case question.qtype
        when 'Select One', 'Yes/No', 'True/False' then
          errors.add :single_choice_id, 'You must respond to this question' if single_choice_id.blank?
        when 'Select Multiple' then
          errors.add :multiple_choice_ids, 'You must respond to this question' if multiple_choice_ids.blank?
        when 'Text' then
          errors.add :text_response, 'You must respond to this question' if text_response.blank?
        when 'Date', 'Date/Time', 'Time' then
          errors.add :datetime_response, 'You must respond to this question' if datetime_response.blank?
        when 'Numeric' then
          errors.add :numeric_response, 'You must respond to this question' if numeric_response.blank?
      end
    end
  end
  
  def previous_response
    participant.responses.
      joins('join survey_questions on survey_questions.id = participant_responses.question_id').
      where('survey_questions.position < ?', question.position).
      order('survey_questions.position desc').
      first
  end
  
  def destroy_following_responses!
    participant.responses.
      joins('join survey_questions on survey_questions.id = participant_responses.question_id').
      where('survey_questions.position > ? and survey_questions.survey_id = ?', question.position, question.survey_id).
      destroy_all
  end

  protected

    def set_next_question    
      next_question = nil
      questions_unanswered = question.survey.questions.where('position > ?', question.position)
      questions_unanswered.each do |question|
        if question.parent_choice
          if earlier_response = participant.responses.find_by_question_id(question.parent_choice.question.id)
            if earlier_response.choices.collect(&:id).include? question.parent_choice.id
              next_question = question
              break
            end
          end
        else
          next_question = question
          break
        end
      end
      participant_survey.update_attribute :next_question, next_question
    end
    
    def check_and_set_complete
      if participant_survey.next_question.nil? or all_required_questions_answered?
        participant_survey.update_attribute :complete, true
      end
    end
    
    def all_required_questions_answered?
      true if question.survey.questions.where('position > ? and required = true', question.position).count == 0
    end
end
