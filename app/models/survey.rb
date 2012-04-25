class Survey < ActiveRecord::Base  
  belongs_to :member
  has_many :participants, :class_name => 'ParticipantSurvey', :dependent => :destroy
  has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
  has_many :root_questions, :class_name => 'SurveyQuestion', :dependent => :destroy, 
    :conditions => "survey_question_choice_id is null or survey_question_choice_id = 0"
  has_one :target, :as => :targetable, :dependent => :destroy
  has_many :forks, :class_name => 'Survey', :foreign_key => :forked_from_id, :dependent => :nullify
  belongs_to :forked_from, :class_name => 'Survey'
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :downloads, :class_name => 'SurveyDownload', :dependent => :destroy
  has_and_belongs_to_many :reports
  
  attr_accessor :changes_requested_by

  accepts_nested_attributes_for :target

  default_scope order('surveys.created_at desc')
  scope :drafting, where(:state => 'drafting')
  scope :piloting, where(:state => 'piloting')
  scope :review_requested, where(:state => 'review_requested')
  scope :rejected, where(:state => 'rejected')
  scope :live, where(['state in (?)', %w{published launched closed}])
  scope :closed_or_published, where(['state in (?)', %w{published closed}])
  scope :launched, where(:state => 'launched')
  scope :closed, where(:state => 'closed')
  scope :published, where(:state => 'published')
  scope :owned_or_collaborating, lambda {|member_id|
    where('surveys.member_id = :id or collaborators.member_id = :id', :id => member_id).
    joins("left outer join collaborators on collaborators.collaborable_type = 'Survey' and collaborable_id = surveys.id")
  }
  scope :not_by_visitor, where('member_id != 0 and member_id is not null')
  
  acts_as_taggable
  acts_as_followable
  include Extensions::Versionable
  include Extensions::SurveyForDiff
  include Extensions::Collaborable
  
  amoeba do 
    enable
    include_field :root_questions
    include_field :target
    include_field :taggings
  end

  validates_presence_of :title, :description
  validates_presence_of :member_id, :on => :update
  validates_length_of :title, :minimum => 3
  validates_numericality_of :cohort_interval_in_days, :cohort_range_in_days, :minimum => 1, :allow_blank => true
  validates_numericality_of :cohort_range_in_days, :minimum => 1, :allow_blank => true
  validate :settings_for_draft
  
  searchable do
    text :title, :boost => 5.0
    text :description
    text :purpose_of_survey
    text :uses_of_results
    text :organization_name
    text :irb_name
    text :tag_list
    text :nickname do 
      member.try :nickname
    end
    text :questions do 
      questions.collect do |question|
        question.body + ', ' + question.choices.collect(&:label).join(', ')
      end.join(', ')
    end
    boolean :published do 
      live?
    end
    string :state
    integer :id
  end
  
  handle_asynchronously :solr_index
  
  def settings_for_draft
    if drafting? and state_was == 'drafting'
      if irb?
        errors.add :irb_name, 'is required if IRB is checked' if irb_name.blank?
        errors.add :irb_phone, 'is required if IRB is checked' if irb_phone.blank?
        errors.add :irb_email, 'is required if IRB is checked' if irb_email.blank?
      end
      if organization?
        errors.add :organization_name, 'is required if Organization is checked' if organization_name.blank?
        errors.add :organization_phone, 'is required if Organization is checked' if organization_phone.blank?
        errors.add :organization_email, 'is required if Organization is checked' if organization_email.blank?
      end
      if cohort?
        if cohort_interval_in_days.blank?
          errors.add :cohort_interval_in_days, 'is required if Cohort is checked'
        end
        if cohort_range_in_days.blank?
          errors.add :cohort_range_in_days, 'is required if Cohort is checked'
        end
      end
    end
  end
  
  attr_protected :state

  state_machine :state, :initial => :drafting do
    state :drafting
    state :piloting
    state :review_requested
    state :rejected
    state :launched
    state :closed
    state :published
    state :hidden

    event :request_review do
      transition :drafting => :review_requested
    end

    event :pilot do
      transition :drafting => :piloting
    end

    event :stop_pilot do
      transition :piloting => :drafting
    end

    event :request_changes do
      transition :review_requested => :drafting
    end

    event :reject do
      transition :review_requested => :rejected
    end

    event :launch do
      transition :review_requested => :launched
    end

    event :close do
      transition :launched => :closed
    end

    event :publish do
      transition :closed => :published
    end

    after_transition :drafting => :piloting do |survey, transition|
      survey.participants.destroy_all
    end

    after_transition :piloting => :drafting do |survey, transition|
      survey.participants.destroy_all
    end

    after_transition any => :review_requested do |survey, transition|
      Member.admins.each {|m| m.delay.notify!(survey, "#{survey.member.nickname} submitted a survey for review")}
      survey.member.delay.notify!(survey, 'Your survey was received for review')
    end

    after_transition :review_requested => :drafting do |survey, transition|
      survey.member.delay.notify!(survey, 'Your survey did not pass our review')
      survey.member.delay.message!(survey.changes_requested_by, Member.admins.all, "As your survey, #{survey.title}, did not pass our review, please see our survey guidelines in the Docs section of our site, make changes accordingly, and launch your survey once again. Please contact us if you have any questions or comments.")
      survey.member_followers.each {|m| m.delay.notify!(self, "#{survey.member.nickname}'s survey did not pass our review")}
    end

    after_transition any => :rejected do |survey, transition|
      survey.member.delay.notify!(survey, 'Sorry, your survey was rejected')
      survey.member_followers.each {|m| m.delay.notify!(self, "#{survey.member.nickname}'s survey was rejected")}
    end

    after_transition any => :launched do |survey, transition|
      survey.participants.destroy_all
      survey.member.notify!(survey, 'Yay, your survey has launched')
      survey.member_followers.each {|m| m.notify!(self, "#{survey.member.nickname}'s survey was opened for participation")}
    end

    after_transition any => :closed do |survey, transition|
      Member.admins.each {|m| m.delay.notify!(survey, "#{survey.member.nickname}'s survey was closed, results are coming soon")}
      survey.member_followers.each {|m| m.delay.notify!(survey, "#{survey.member.nickname}'s survey was closed, results are coming soon")}
      survey.delay.publish!
    end

    after_transition any => :published do |survey, transition|
      ParticipantSurvey.compute_weights_for_survey! survey
      SurveyDownload.generate_for_survey! survey
      survey.member.delay.notify!(survey, 'Yay, your survey results have been published')
      survey.member_followers.each {|m| m.delay.notify!(survey, "#{survey.member.nickname}'s survey results have been published")}
    end
  end

  def live?
    %w{published launched closed}.include? state
  end

  def may_edit?(member)
    if member
      if member.admin? and member.id != member_id
        true unless live? or rejected? or piloting?
      elsif member.id == member_id or collaborator_ids_a.include?(member.id)
        true unless live? or review_requested? or rejected? or piloting?
      end
    end
  end
  
  def may_access?(member)
    true if member and (member.admin? or member.id == member_id or collaborator_ids_a.include?(member.id))
  end
  
  def pilot_open?
    true if piloting? and completes < 30
  end
  
  def results_available?(member)
    if member
      if member.admin? or member.id == member_id or collaborators.collect(:member_id).includes?(member.id)
        true if published? or closed? or launched? or piloting?
      else
        true if published? or closed?
      end
    end
  end

  def forkit!(member_id)
    Survey.transaction do 
      new_survey = self.dup
      new_survey.forked_from = self
      new_survey.member_id = member_id 
      new_survey.state = 'drafting'
      new_survey.root_questions.clear
      new_survey.save!
      forkit_questions_helper(new_survey, root_questions)
      return new_survey
    end
  end
  
  def forkit_questions_helper(new_survey, questions, parent_choice=nil)
    questions.each do |question|
      new_question = new_survey.questions.build question.attributes
      new_question.survey = new_survey
      new_question.parent_choice = parent_choice
      new_question.save!
      if question.qtype == 'Select Multiple' or question.qtype = 'Select One'
        question.choices.each_with_index do |choice, index|
          new_choice = new_question.choices[index]
          forkit_questions_helper(new_survey, choice.child_questions, new_choice)
        end
      end
    end
  end

  def load_version(version)
    SurveyQuestion.class 
    SurveyQuestionChoice.class 
    Target.class
    survey = Marshal.load(Base64.decode64(version.data))
    self.attributes = survey.attributes.except('id', 'state')
    self.root_questions = survey.root_questions
    self.target = survey.target
    self.taggings = survey.taggings
    self
  end
  
  def state_human
    case state
      when 'drafting' then 'Drafting'
      when 'piloting' then 'Piloting'
      when 'review_requested' then 'Review requested'
      when 'launched' then 'Open'
      when 'rejected' then 'Rejected'
      when 'closed' then 'Closed, results pending publication'
      when 'published' then 'Closed, results published'
      when 'hidden' then 'Hidden'
    end
  end

  def update_question_positions!(positions)
    index = 1
    questions_2 = {}
    questions.all.each {|q| questions_2[q.id] = q}
    positions.each_pair do |id, choice_id|
      question = questions_2[id.to_i]
      choice_id = nil if choice_id == 'root'
      if question.position != index or question.survey_question_choice_id.to_i != choice_id.to_i
        question.update_attributes :position => index, :survey_question_choice_id => choice_id
      end
      index += 1
    end
  end
  
  def tidy_positions!
    questions.each_with_index do |question, index|
      if question.position != index + 1
        question.update_attribute :position, index + 1
      end
    end
  end

  def total_surveys
    if cohort?
      if cohort_range_in_days == -1
        -1
      else
        (cohort_range_in_days / cohort_interval_in_days).floor
      end
    else
      1
    end
  end

  def total_surveys_human
    if total_surveys > 0
      total_surveys.to_s
    else
      'Indefinitely'
    end
  end

  def cohort_interval_in_days_human
    c = Survey.cohort_interval_options.select {|c| c[1] == cohort_interval_in_days}.first
    c[0].downcase if c
  end

  def cohort_range_in_days_human
    c = Survey.cohort_range_options.select {|c| c[1] == cohort_range_in_days}.first
    c[0].downcase if c
  end

  def self.cohort_interval_options
    [
      ['Every day', 1.0],
      ['Weekly', 7.0],
      ['Every other week', 14.0],
      ['Monthly', 30.45],
      ['Every other month', 30.45 * 2],
      ['Four times a year', 30.45 * 3],
      ['Three times a year', 30.45 * 4],
      ['Two times a year', 30.45 * 6],
      ['Yearly', 365.25],
      ['Every other year', 730.5]
    ]
  end

  def self.cohort_range_options
    [
      ['One week', 7.0],
      ['Two weeks', 14.0],
      ['One month', 30.45],
      ['Two months', 30.45 * 2],
      ['Three Months', 30.45 * 3],
      ['Four Months', 30.45 * 4],
      ['Five Months', 30.45 * 5],
      ['Six Months', 30.45 * 6],
      ['One Year', 365.25],
      ['Two Years', 365.25 * 2],
      ['Indefinitely', -1.0],
    ]
  end

  def posted_by
    member.nickname if member
  end
  
  def human 
    title
  end
  
  def completes
    ParticipantSurvey.where('survey_id = ? and complete = true', id).count
  end
  
  def incompletes
    ParticipantSurvey.where('survey_id = ? and complete = false', id).count
  end
  
  def completes_by_gender
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).group('gender_id').count
    Gender.all.collect {|g| {:label => g.label, :id => g.id, :total => (totals[g.id] || 0)}}
  end
  
  def completes_by_age_group
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).group('age_group_id').count
    AgeGroup.all.collect {|a| {:label => a.label, :id => a.id, :total => (totals[a.id] || 0)}}
  end
  
  def completes_by_education
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).group('education_id').count
    Education.all.collect {|e| {:label => e.label, :id => e.id, :total => (totals[e.id] || 0)}}
  end
  
  def completes_by_ethnicity
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).
      joins('join ethnicities_participant_surveys eps on eps.participant_survey_id = participant_surveys.id').
      group('ethnicity_id').count
    Ethnicity.all.collect {|e| {:label => e.label, :id => e.id, :total => (totals[e.id.to_s] || 0)}}
  end
  
  def completes_by_race
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).
      joins('join participant_surveys_races psr on psr.participant_survey_id = participant_surveys.id').
      group('race_id').count
    Race.all.collect {|r| {:label => r.label, :id => r.id, :total => (totals[r.id.to_s] || 0)}}
  end
  
  def completes_by_region
    totals = ParticipantSurvey.where('survey_id = ? and complete = true', id).group('region_id').count
    Region.all.collect {|r| {:label => r.label, :id => r.id, :total => (totals[r.id] || 0)}}
  end
  
  def completes_by_state
    ParticipantSurvey.where('survey_id = ? and complete = true', id).group('state').count
  end
  
  def incompletes_by_gender
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).group('gender_id').count
    Gender.all.collect {|g| {:label => g.label, :id => g.id, :total => (totals[g.id] || 0)}}
  end
  
  def incompletes_by_age_group
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).group('age_group_id').count
    AgeGroup.all.collect {|a| {:label => a.label, :id => a.id, :total => (totals[a.id] || 0)}}
  end
  
  def incompletes_by_education
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).group('education_id').count
    Education.all.collect {|e| {:label => e.label, :id => e.id, :total => (totals[e.id] || 0)}}
  end
  
  def incompletes_by_ethnicity
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).
      joins('join ethnicities_participant_surveys eps on eps.participant_survey_id = participant_surveys.id').
      group('ethnicity_id').count
    Ethnicity.all.collect {|e| {:label => e.label, :id => e.id, :total => (totals[e.id.to_s] || 0)}}
  end
  
  def incompletes_by_race
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).
      joins('join participant_surveys_races psr on psr.participant_survey_id = participant_surveys.id').
      group('race_id').count
    Race.all.collect {|r| {:label => r.label, :id => r.id, :total => (totals[r.id.to_s] || 0)}}
  end
  
  def incompletes_by_region
    totals = ParticipantSurvey.where('survey_id = ? and complete = false', id).group('region_id').count
    Region.all.collect {|r| {:label => r.label, :id => r.id, :total => (totals[r.id] || 0)}}
  end
  
  def incompletes_by_state
    ParticipantSurvey.where('survey_id = ? and complete = false', id).group('state').count
  end
  
  def completes_download
    downloads.where(:dtype => 'completes').first
  end
  
  def incompletes_download
    downloads.where(:dtype => 'incompletes').first
  end
  
  def data_dictionary_download
    downloads.where(:dtype => 'data_dictionary').first
  end
  
  def set_weights!
    census = Census.find_by_year(created_at.year)
    if target.target_by_location?
      case target.location_type 
        when 'address' then 
          if not target.city.blank? 
            geos = census.geos.where(:city => target.city, :state => target.state)
          elsif not target.state.blank?
            geos = census.geos.where(:state => target.state)
          elsif not target.country.blank? and target.country != 'US'
            geos = census.geos.where(:state => target.state)
            return false
          end
        when 'vicinity' then
          unless target.lat.blank? or target.lng.blank? or target.radius.blank?
            census.geos.near([target.lat, target.lng], target.radius, :km)
          end
        when 'region' then
          unless target.lat.blank? or target.lng.blank? or target.radius.blank?
            census.geos.near([target.lat, target.lng], target.radius, :km)
          end
        else return false
      end
    else
      census.geos
    end
    weights = {}
  end
  
  def to_param
    "#{id} #{title}".parameterize
  end
  
  def self.destroy_old_visitor_surveys!
    Survey.where('member_id = 0 or member_id is null and created_at < ?', 1.month.ago).destroy_all
  end
  
  def cache_key
    "#{super}-#{state}-#{questions.count}-#{versions.count}-#{collaborators.count}"
  end
end
