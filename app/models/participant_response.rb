class ParticipantResponse < ActiveRecord::Base
  belongs_to :participant
  has_and_belongs_to_many :multiple_choices, :class_name => 'SurveyQuestionChoice'
  belongs_to :single_choice, :class_name => 'SurveyQuestionChoice'
  belongs_to :question, :class_name => 'SurveyQuestion'

  validates_presence_of :participant, :question
  validates_uniqueness_of :question_id, :scope => :participant_id
  validates_numericality_of :numeric_response, :allow_blank => true, :only_integer => true
  validate :question_required

  after_create :set_next_question

  def choices
    (multiple_choices + [single_choice]).compact
  end

  def question_required
    if question.required?
      case question.qtype
        when 'Select One' then
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
      participant.surveys.find_by_survey_id(question.survey.id).update_attribute :next_question, next_question
    end
end
