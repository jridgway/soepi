class ParticipantSurvey < ActiveRecord::Base
  belongs_to :participant
  belongs_to :survey
  belongs_to :gender
  has_and_belongs_to_many :ethnicities
  has_and_belongs_to_many :races
  belongs_to :education
  belongs_to :next_question, :class_name => 'SurveyQuestion'

  validates_presence_of :survey_id, :city, :region, :postal_code, :country,
    :birthmonth, :gender_id, :ethnicity_ids, :race_ids, :education_id

  before_create :set_next_question

  def set_next_question
    self.next_question = survey.questions.first
  end

  def complete?
    true unless next_question
  end

  def apply_member(member)
    self.gender = member.gender
    self.birthmonth = member.birthmonth
    self.city = member.city
    self.region = member.region
    self.postal_code = member.postal_code
    self.country = member.country
    self.ethnicities = member.ethnicities
    self.races = member.races
    self.education = member.education
  end
end
