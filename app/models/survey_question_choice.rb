class SurveyQuestionChoice < ActiveRecord::Base
  belongs_to :question, :class_name => 'SurveyQuestion', :foreign_key => 'survey_question_id'
  has_and_belongs_to_many :multiple_responses, :class_name => 'ParticipantResponse'
  has_many :single_responses, :class_name => 'ParticipantResponse'
  has_many :child_questions, :class_name => 'SurveyQuestion', :dependent => :destroy

  default_scope order('position asc, created_at asc')

  validates_presence_of :label
  validates_uniqueness_of :label, :scope => 'survey_question_id'
end
