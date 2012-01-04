class ParticipantSurvey < ActiveRecord::Base
  belongs_to :participant
  belongs_to :survey
  belongs_to :gender
  belongs_to :age_group
  belongs_to :region
  has_and_belongs_to_many :ethnicities
  has_and_belongs_to_many :races
  belongs_to :education
  belongs_to :next_question, :class_name => 'SurveyQuestion'
  has_many :responses, :class_name => 'ParticipantResponse'

  validates_presence_of :participant_id, :survey_id, :city, :state, :postal_code, :country,
    :age_group_id, :gender_id, :ethnicity_ids, :race_ids, :education_id, :next_question_id

  before_create :apply_participant, :set_next_question
  after_destroy :clear_statistics
  
  scope :for_survey, lambda {|survey_id| where(:survey_id => survey_id, :complete => true)}
  scope :completes, where(:complete => true)
  scope :incompletes, where(:complete => false)

  def complete?
    true unless next_question
  end
  
  def apply_participant
    self.gender_id = participant.gender_id
    self.age_group_id = participant.age_group.id
    self.city = participant.city
    self.state = participant.state
    self.postal_code = participant.postal_code
    self.country = participant.country
    self.region_id = participant.region.try(:id)
    self.lat = participant.lat
    self.lng = participant.lng
    self.ethnicity_ids = participant.ethnicity_ids
    self.race_ids = participant.race_ids
    self.education_id = participant.education_id
  end

  def set_next_question
    self.next_question_id = survey.questions.first.id
  end

  def responses
    participant.responses.joins('join survey_questions sq on sq.id = participant_responses.question_id').
      where('sq.survey_id = ?', survey_id).order('sq.position asc')
  end
  
  def self.compute_weights_for_survey!(survey)
    ParticipantSurvey.for_survey(survey.id).update_all 'weight = 1.0'
  end
    
  protected
    
    def clear_statistics
      Statistic.delete_all
    end
end
