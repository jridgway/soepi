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

  validates_presence_of :survey_id, :city, :state, :postal_code, :country,
    :age_group_id, :gender_id, :ethnicity_ids, :race_ids, :education_id

  before_create :set_ids_caches
  before_create :set_next_question
  after_destroy :destroy_responses, :clear_statistics

  def set_next_question
    self.next_question = survey.questions.first
  end

  def complete?
    true unless next_question
  end

  def apply_member(member)
    self.gender = member.gender
    self.age_group = member.age_group
    self.city = member.city
    self.state = member.state
    self.postal_code = member.postal_code
    self.country = member.country
    self.region = member.region
    self.ethnicities = member.ethnicities
    self.races = member.races
    self.education = member.education
  end
  
  private
    
    def destroy_responses
      ParticipantResponse.where('participant_id = ? and question_id in (?)', participant.id, survey.question_ids).destroy_all
    end
    
    def clear_statistics
      Statistic.delete_all
    end
    
    def set_ids_caches
      self.race_ids_cache = race_ids.sort.join(',')
      self.ethnicity_ids_cache = ethnicity_ids.sort.join(',')
    end
end
